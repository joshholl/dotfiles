-- nvim-jdtls: Java LSP via Eclipse JDT Language Server
-- Actual setup happens in ftplugin/java.lua (called per buffer)
return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },
}
