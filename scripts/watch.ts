import watch from "node-watch";
import { exec } from "child_process";

const run = () => {
  console.log("🛠  Compiling & Deploying...");
  exec("npm run deploy:hardhat", function (error, stdout, stderr) {
    console.log(stdout);
    if (error) console.log(error);
    if (stderr) console.log(stderr);
  });
};

console.log("🔬 Watching Contracts...");
watch("./contracts", { recursive: true }, function (evt, name) {
  console.log("%s changed.", name);
  run();
});
run();
