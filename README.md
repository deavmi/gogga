<p align="center">
<img src="branding/logo_banner.png" width=450>
</p>

<br>

<h3 align="center"><i><b>Simple VT100 colourised thread safe pretty-printing logger</i></b></h3>

---

<br>
<br

## Usage

The API is rather straight-forward, simply create a new logger and then you can use it as such:

```d
import gogga;

GoggaLogger gLogger = new GoggaLogger();

gLogger.info("This is an info message");
gLogger.warn("This is a warning message");
gLogger.error("This is an error message");
```

This should output something like the following:

![](example.png)

