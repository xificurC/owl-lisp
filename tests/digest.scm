(import (owl digest))

(define (shorten x)
   (s/(....).....*(....)/\1...\2/ x))

(define (test name digest input wanted)
   (let ((res (digest input)))
      (if (equal? res wanted)
         (print "OK " name "(" (shorten input) ") = " res)
         (print "   " name "(" (shorten input) ") = " res " instead of " wanted "!"))))

(test "SHA1" sha1 "" "da39a3ee5e6b4b0d3255bfef95601890afd80709")
(test "SHA1" sha1 "a" "86f7e437faa5a7fce15d1ddcb9eaeaea377667b8")
(test "SHA1" sha1 "aa" "e0c9035898dd52fc65c41454cec9c4d2611bfb37")
(test "SHA1" sha1 "aaa" "7e240de74fb1ed08fa08d38063f6a6a91462a815")
(test "SHA1" sha1 "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" "8eca554631df9ead14510e1a70ae48c70f9b9384")
(test "SHA1" sha1 "RUcprOxLRHToyhsMvvdWwcdJzxWsaJsiIoDdQVJKdDCFqbuWExNoUpvzOwzcGvuRqXEkxXOrbJNXPNYDVFmgIofuLQOjLrAiroiplXGZpaLMeydkPKZkgmssuMtlftwGEsAeOhwUBEjopUodKddgOSDPbqKqdEVXdpjgMRnSlVuBfpTYWvpCDQGrzvhufMttOaEAPXgqwYeVvomxqwFLbmdJUfVAFFCOYljNfKUgRMbaSYMMrDaidVNCzyMcTCRnqktdBqoJXxsUgrpCKQDDKoIUshNSvvwKXgUbpcIHqKPMvdgYAjPsAYnbOcqswgtKTttVPUCKtuotUcJFwuOZscxAqPtLvKnKeibIjDMkCwEhTmsyHkZBWLTDNGGiJvCqblIAokrPDopwEqNIbtAZAxALeJcPWUXBQdlsZcowhrYJkpvVgGXVzFjmrWGYXXcMGDnzzTqrsAzIRjVaQhUvEgRQyrXuEQoxFIYQwuJTaOYSOxUppkrOEAtxjhoUuWGcwfdIiqXvdQZkMLnYgKTTgUoLZopzArVCobcoxlCANFOePjVidOcxXwzKEbOSJqHOxBNbCwbWiiwZsAXUkBzpzDEMzOHMGJAVxzAXescZhpDXEVYzzxIzzmbbxfSqXeUFGDSEkJHPXSlbUffBgXrRRIBmqSRHSClEeSAKyksJzluINPPqSRUCtiPChRuuhioldKzGTgTJfOBZNdGwvOdTtQjnCsnwyjPhtCzCsvqAQnsMtkVDWXfkzgPpTSretCpzEASJKMOhvsjoyTVhGTlBoOHeLWktwTUESHbDqwojgOUiTLpabRtFuYwxxqfWWKCWmZTdmyQWLbzZWFUmUaKkIcvURHtORbMiluvxHTRNWTFAQpSilxwDcdVBmfAGIjaEbhqhoNLDUaeScKQLJkbuZOcPNDSFJtVmnVpIvrFUEsWapMTbLCRrAQXWZgcapjqvbwlRHhSHkseUbkxWyalUZThHqtNybmTLfQdZudMvaZpGhDYufBiUZLlobXyULcimyfIEbPtJCGjaabTugpsGoXLKWpBEjoiYGhcHDdtrFnbGeKugzPLxjdquWvBsTATsKFfqCkVDzrJwUCNuEmtJEDwtYKVdpQvarrpSAuPHCFSqJLfCDssSvKPTqaXcKJtyOHWqScpaYbnhqfqLSmpsrnHAAIGZEzMYdbwEfNemWTNYagUyZXOsMZpMGSbrtUhXVyRDPZrwKMNcYVxsgCePWXGQqrcegpHmZhEjrZQBoCtCHZSqJARmKGfsUYaoGufMrQNQWnWmXmjGRKmLCoIHoTIxJeiSJImFYDyJoXEkArAsekffAGIsnjkXDLIMwfcPzmnxgtxwdfXLHfXgYElqhhDafSnPdVdWLbKlNlkTupVzYFWAlojujJvjKaFfyitHDHPEajfmrTYAyLkyspjoXIsnDXSOSHAKPUPYftCTclKGVuVMVVNleVUsNlyRiXOUoqbWyvDgNvhpQQHvwdnTgXDOmmgEqEDDESLIWJUZUxZBGQEPMizqhddFWgxDLPAsyWhIbhlDjMLJdOverqWuSluMVjGZVCpgLHwTQZWsxhlOhvOYmPqDphNEmHGgacjueybziXogdTKaosooOrsTSZlfeZZKibEiUKpzXAtpjnFmXCLeNDgScAvrpZDCyOPREUPMOWzeeRsBplwCkqPclROucLUfdAsxkIwiaiiigzFzwRJwvPYERFWQwUkxYfuisceTIdFImwjgYXOzJQGvdtABMnJOVYzSdFJPnpXDCrNeOzOCWUTLxdfUYrNTIkBPgJZRDImGFzNCZYPvrXfCEjKDfyUlSbABbyMsffsJNPGGpUCQdoOiQdtwOCmhPswlPlHDXviJvRXFMizqDWeKaWoGEFzlXLaKWFNzPdUsqnywxZbRRwchEBNyplFbgHcPxotiyEhuCUscGmytFGPajMRuUxpQslcHSlSjPlNjddbQZCwedvArEZzkrVLoGCHZuIqOhIjDbZEgYasUXkmSDqPvOulxXVHxMsEZUicJjznqaJiEnayVFDSIkZJdjRfGkNuBvjpnYIkrutYWZQMHVBWpQjPSsPOwnVGQyYKljuTzgGhHmZhNBjnwpsXdopaIhzwgmwwiKjmUNzengjfokufAVSkVJuLOLtTXiTryLgLKaUwvJyWtQYMmDNXHfeidhBperEExSoheulpMEHbYJHsnsTQZOYQXxqdkiMIGrxyTVannTGhPMcEIBpwdZgmThcpSTlxGukXcZJNAMERMYpfScDzccWeTEZaacaMiQyhpalnTkPVOMtoRknkzCYHeQiccDFIgNyRGYsBrPPVGCeoxadvlEjXfaxOciflzdLmtmSkqKFfSDBHKctgdmStnttaNdzRPWCfFXNSnwNfCaSJLtYMaUGbheybPgmZUIApHaArFBmCjLqLRKfPtGfQOASsZzOdBHbAmreaDNQqQrdbWxhARUpFnXMUuBiSYGFJwIYYXXtgtKibpoqCcBbXGoWKFIVAXJEmnIjnfcuuWqpdXafqGWRshZhufeJmBoLfWcKNFXcqlTKcWGaWzZPEKAQcdAicoUxHAndPfsfytBTwyupEvRrnpnkPlpNeOMICFZKkhkfFcWEdvTPYvESXbkjsCNfvSvkwBfCZVyejWcXXKeQyDEiyPTKiKlDhQBvxKmevmdpGrCdjVvmzuSsGJUwPzfQsfepMosvDkbuVigaWRWIrjUcHcXYxkEodWZCBljBHKHOkVZnhlfYfMLJmHnwzcqoyhtQnzcdZmcHOTguXMuUzgIRrWXUqknNXGEAovxJHXhBeoeOcFMMuphhcxsXKNhDSBCsexrVITnMXxPvsbMhofMCmlqVRuVaTjFfbhAHmWtzdqyedXvAUeiwWPzzHQUubJIlpAOdHXSKVxDeeXJubLIApdSrYcJiiFULgqLYuzGHgFwWEZUPOJJbkjLLjXLFoZonAdWIXnPJHCuCTdsVVNkMUoqaZKhIVMRAFQVMrzmzsVfTpWDrKsNQpuRPaoDxIXcihLNywPIdjgjfDMoneKHWCSCUdLMotYTtolrxUXMvrmSxsZSTmjgpjKdXsVQXdyZNrpijpPCiKeBTYFmkjIXaNLvGqzgYqTKIrwOovJSNbjziMCsMzLWLIvSPmTTqBzUPmTlHSwHRfGWmPtUQvLjCNgNCnpObBoCtUBsynyoxdDrGyfZwEPNnenXLoUGBiEgvrbvMklTxAGWZtRHhMtDblLvUKmFXheslsazShGXpMVxmwMdDFbwByElRZAOGXIgtPqOwHpKtVtBRwMVcOXwbCdmCqLxAXUaKcrQWyrarrOPfEHFyEWFtfHUVjeVopDxPKASTziVdYwqfeFYuLUJoSCCjBfQsFecdXWtVhrfqDlSYwrNDlMPvqigGpWQNjIuFhdPtLLramiFepcsyXwoiUJgNQDrQzYcvKZfHnlKjHCVaKeOqevmMTqfnxApoFKRcnmPuzjHieJPzclfnPShfqkjRhTvpJxKPcayNlkFtdXMHvXhtCfovVWSiSOiYQiOdZnrjjuQgIzztgZSmqPLUDMZMbIBEuuMLJsABqRPvdxEMyKjsFMvbLTbzpnjWuHkVsyOoYkfqMopWQQEIhFTGQyQnTnFHAYFDgLQXyvpOWAIgtijTwgHRrneaueTEYzfqJkWJDCjbGhrbWRdfaXdiksPlrmNLvdEMPNDeEWUxpDheEAkNTAFPVCZNaYPPqnSCMArnVdJRqgfATuPqrzDInpylTrbXruVygbjOvKsuTmDwQPmFIUwUyHlBgGIPbNKPfKcYRIzBozJzPtHQzNqWgoxgUyoDxYKJQglxMANUgqJMkFjswTNsyhDWhIBbzqIYCwoLSfnxwTnJdbekCBoWGmKpzpdomCbImYjfvHrguIvFdAZLlhVjuwbJvUNWULnuugnIqFNGtpZHBgzWfXJEcDLPVEXScoQyklvMqRtDMwGSOUQUHaCSIcNaHAzjaYhmcSjwpEzMVCXtBJAKUIpNExiqfJnKMjOMtbemOUpvTYmOLxZmoFMceHAssacHHAyYVtdSeGsqqkmWkQJgPMtjqUimcoOUHNXhOxUdUxcaPSrJByGcZAbMRH" "0756a3fa3cc329c9e1eed4857a3d9088606ce590")
