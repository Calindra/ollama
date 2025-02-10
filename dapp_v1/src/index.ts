import createClient from "openapi-fetch";
import { components, paths } from "./schema";
import { exec } from "node:child_process";
import { setTimeout } from "node:timers/promises"
type AdvanceRequestData = components["schemas"]["Advance"];
type InspectRequestData = components["schemas"]["Inspect"];
type RequestHandlerResult = components["schemas"]["Finish"]["status"];
type RollupsRequest = components["schemas"]["RollupRequest"];
type InspectRequestHandler = (data: InspectRequestData) => Promise<void>;
type AdvanceRequestHandler = (
  data: AdvanceRequestData
) => Promise<RequestHandlerResult>;

const rollupServer = process.env.ROLLUP_HTTP_SERVER_URL;
console.log("HTTP rollup_server url is " + rollupServer);

const runCommand = (command: string): Promise<string> => {
  return new Promise((resolve, reject) => {
    exec(command, (error, stdout, stderr) => {
      if (error) {
        reject(`Error: ${error.message}`);
        return;
      }
      if (stderr) {
        reject(`Stderr: ${stderr}`);
        return;
      }
      resolve(stdout);
    });
  });
};

const exampleFetcher = async () => {
  console.log("Fetching example");
  try {
    const response = await fetch("http://127.0.0.1:11434/api/generate", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "smollm:135m",
        prompt: "Hi",
        stream: false,
      }),
    });
    console.log("Response", response);
    const data = await response.json();
    console.log(data);
  } catch (error) {
    console.error("Error:", error);
  }
};

const handleAdvance: AdvanceRequestHandler = async (data) => {
  const hexString = data.payload.substring(2); // "Hello World" in hex
  const buffer = Buffer.from(hexString, "hex");
  const decodedString = buffer.toString("utf-8");
  console.log("Advance decoded string", decodedString);
  console.log("Received advance request data " + JSON.stringify(data));

  if (decodedString === "oshiro") {
    await setTimeout(10_000);
    await exampleFetcher();
    return "accept"
  }

  try {
    const output = await runCommand(decodedString);
    console.log(`Output:\n${output}`);
  } catch (error) {
    console.error(error);
  }
  return "accept";
};

const handleInspect: InspectRequestHandler = async (data) => {
  const hexString = data.payload.substring(2); // "Hello World" in hex
  const buffer = Buffer.from(hexString, "hex");
  const decodedString = buffer.toString("utf-8");
  console.log("Decoded string", decodedString);

  if (decodedString === "oshiro") {
    await setTimeout(10_000);
    await exampleFetcher();
    return
  }

  try {
    const output = await runCommand(decodedString);
    console.log(`Output:\n${output}`);
  } catch (error) {
    console.error(error);
  }
  console.log("Received inspect request data " + JSON.stringify(data));
};

const main = async () => {
  const { POST } = createClient<paths>({ baseUrl: rollupServer });
  let status: RequestHandlerResult = "accept";
  while (true) {
    const { response } = await POST("/finish", {
      body: { status },
      parseAs: "text",
    });

    if (response.status === 200) {
      const data = (await response.json()) as RollupsRequest;
      switch (data.request_type) {
        case "advance_state":
          status = await handleAdvance(data.data as AdvanceRequestData);
          break;
        case "inspect_state":
          await handleInspect(data.data as InspectRequestData);
          break;
      }
    } else if (response.status === 202) {
      console.log(await response.text());
    }
  }
};

main().catch((e) => {
  console.log(e);
  process.exit(1);
});
