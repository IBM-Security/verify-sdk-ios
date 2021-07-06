# Configuring your environment

## Xcode setup (Swift)

[![Link to video instructions](../res/youtube-ios.png)](https://youtu.be/9xw0f2nDlgM)


1\. After downloading the SDK, extract the contents to a folder.
 
2\. Start Xcode and create a new Swift project.

3\. Open the folder where the SDK was extracted in step 1.  Copy the `Frameworks` folder to the folder where you created the Xcode project in step 2. 
>The `Frameworks` folder should be at the same folder level as the .xcodeproj file.
>

4\. In Xcode, select the top level Project item on the left.  Select the project in the `TARGETS` section.

5\. Select the `General` tab along the top of the middle pane.  Scroll down to the section `Embedded Binaries` and click the **+**.   Click on `Add Other...` and navigate to the `Framework` folder that was copied to your project folder in step 3. Select the `IBMVerifyKit.xcframework`, then click `Open`.

6\. Click `Finish`.

7\. Click on the `Build Settings` tab along the top of the middle pane.

8\. Open `ViewController.swift` and add the following code snippet:

```swift
import IBMVerifyKit
```
>You should notice the autocomplete working, the SDK has been imported correctly.
