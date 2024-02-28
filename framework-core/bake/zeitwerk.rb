# Check Zeitwerk eager-loading
def check
  call("framework:application")
  Zeitwerk::Loader.eager_load_all
end
