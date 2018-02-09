     h debug
     h fixnbr(*zoned : *inputpacked)
     h copyright('(c) Finastra International Limited 2005')
 
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Extension (Reg Rpting CRN001)')
      *****************************************************************
      *                                                               *
      *  MidasPlus - Standing Data Module                             *
      *                                                               *
      *  SD000040 - Maintenance of Regulatory Reporting extension     *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG11157           Date 06Apr06               *
      *                 BUG9233            Date 04Jan06               *
      *                 BUG10154           Date 27Jan06               *
      *                 CRN001  *Create    Date 31Oct05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG11157 - Add new field CPRTYRES US counterparty residence  *
      *              to customer extension file.                      *
      *  BUG9233  - Include ? processing                              *
      *  BUG10154 - Reference to pulldown data is incorrect.          *
      *  CRN001 - FRS Regulatory Reporting Interface                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     fsdcustxb  uf a e           k disk    infsr(*pssr)
     f                                     commit
     f                                     usropn
 
     frncpytpd  if   e           k disk    infsr(*pssr)
     frnecscpd  if   e           k disk    infsr(*pssr)
     frnexcrpd  if   e           k disk    infsr(*pssr)
     frnsectpd  if   e           k disk    infsr(*pssr)
     frnicptpd  if   e           k disk    infsr(*pssr)
     frnctyupd  if   e           k disk    infsr(*pssr)                                     BUG11157
 
     fgppdwhl0  if   e           k disk    infsr(*pssr)                                      BUG9233
     f                                     usropn                                            BUG9233
     fgppdwnl0  if   e           k disk
 
     fsd000040dfcf   e             workstn infsr(*pssr)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     d inPssr          s               n
 
     d qCmdExc         pr                  extpgm('QCMDEXC')
     d                              256    const
     d                               15  5 const
 
     d cmdOvrdbf       c                   'OVRDBF FILE(SDCUSTXB) +
     d                                      WAITRCD(5)'
     d cmdDltovr       c                   'DLTOVR FILE(SDCUSTXB)'
 
     d lenOvrdbf       c                   %len(cmdOvrdbf)
     d lenDltovr       c                   %len(cmdDltovr)
 
     d                sds
     d psJobname             244    253
     d psModule              344    353
 
     d pRtnMsg         s              7
     d pCust           s                   like(bbcust)                         I:Key field 1
     d pAction         s              1
 
     d rundat        e ds                  dtaara
 
     d pRtnCod         s              7
     d pOption         s              7
     d pSar            s              6
 
     d zapgmq          s             10
     d zapgrl          s              5
     d zamsid          s              7
     d zamsgf          s             10
     d zamsda          s            132
     d zamstp          s              7
 
      ** parameters to program Y2SNMGC with msg from Y2USRMSG msgf.                          BUG9233
     d zapgmqY2u       s             10                                                      BUG9233
     d zapgrlY2u       s              5                                                      BUG9233
     d zamsidY2u       s              7                                                      BUG9233
     d zamsgfY2u       s             10                                                      BUG9233
     d zamsdaY2u       s            132                                                      BUG9233
     d zamstpY2u       s              7                                                      BUG9233
                                                                                             BUG9233
     d indPtr          s               *   inz(%addr(*in))
     d                 ds                  based(indPtr)
     d   F3_ClientDtl         03     03n                                                     BUG9233
     d   F10_Delete           10     10n
     d   F12_Return           12     12n
 
     d   actnInsert           27     27n
     d   actnAmend            28     28n
     d   actnDelete           29     29n
     d   actnEnquiry          30     30n
     d   protectFlds          31     31n
 
     d   CRN002               32     32n
     d   CRN003               33     33n
     d   CRN004               34     34n
     d   CRN005               35     35n
     d   CRN006               36     36n
 
     d   invEconsect          40     40n
     d   invRiskqual          41     41n
     d   invStriskrt          42     42n
     d   invLtriskrt          43     43n
     d   invCptytype          44     44n
     d   invOwnrperc          45     45n
     d   invRelntype          46     46n
     d   invIntctype          47     47n
     d   invInsttype          48     48n
     d   invChininfl          49     49n
     d   invHkressts          50     50n
     d   invHksectcl          51     51n
     d   invCnsectcl          52     52n
     d   invSgressts          53     53n
     d   invSgsectcl          54     54n
     d   invCprtyRes          55     55n                                                    BUG11157
 
     d inputErr        s               n
 
     d questionMark    s               n                                                     BUG9233
                                                                                             BUG9233
     d invNumInput     pr              n
     d                               10    options(*varsize)
     d                                     const
     d                                3u 0 const
     d                                3u 0 const
     d                               10    varying
 
     d pdwnNotFnd      pr              n
     d                               10    varying
     d                                     const
     d                                3u 0 const
     d                               10s 0 const
 
     d reFmt           s             10    varying
 
     d wKey10_0        s             10  0
     d wKey5_0         s              5  0
 
     d*pdChininfl      c                   58                                                BUG9233
     d*pdHkressts      c                   59                                                BUG9233
     d*pdSgressts      c                   60                                                BUG9233
     d*pdRelntype      c                   61                                                BUG9233
     d*pdInsttype      c                   62                                                BUG9233
     d****pdRiskqual***c                   63                                               BUG10154
     d*pdRiskqual******c                   64                                      BUG10154 BUG11157
     d HiChininfl      s             10  0                                      Header id    BUG9233
     d HiHkressts      s             10  0                                      Header id    BUG9233
     d HiSgressts      s             10  0                                      Header id    BUG9233
     d HiRelntype      s             10  0                                      Header id    BUG9233
     d HiInsttype      s             10  0                                      Header id    BUG9233
     d HiRiskqual      s             10  0                                      Header id    BUG9233
 
     d rcdLocked       c                   01218
 
      ** Working field for %SCAN Operations                                                  BUG9233
      *                                                                                      BUG9233
     d QuestMarkPos    S              3  0                                                   BUG9233
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Declaratives                         ¦
      ** ¦ ============                         ¦
      ** +--------------------------------------+
 
     c     *entry        plist
     c                   parm                    pRtnMsg
     c     #1Cust        parm                    pCust                          I:Key field 1
     c                   parm                    pAction
 
     c     pY2clmsc      plist
     c                   parm      psModule      zapgmq
     c                   parm      '*SAME'       zapgrl
 
     c     pY2snmgc      plist
     c                   parm      psModule      zapgmq
     c                   parm      '*SAME'       zapgrl
     c                   parm                    zamsid
     c                   parm      'SDUSRMSG'    zamsgf
     c                   parm                    zamsda
     c                   parm                    zamstp
                                                                                             BUG9233
     c     pY2snmgcY2u   plist                                                               BUG9233
     c                   parm      psModule      zapgmqY2u                                   BUG9233
     c                   parm      '*SAME'       zapgrlY2u                                   BUG9233
     c                   parm                    zamsidY2u                      to be filled BUG9233
     c                   parm      'Y2USRMSG'    zamsgfY2u                                   BUG9233
     c                   parm                    zamsdaY2u                      to be filled BUG9233
     c                   parm                    zamstpY2u                                   BUG9233
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     c                   exsr      initial
 
     c                   dou       F12_Return
     c                             or F3_ClientDtl                                           BUG9233
     c                             or not inputErr
     c                   exsr      screen1
     c                   enddo
 
     c                   exsr      closedown
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     c     screen1       begsr
 
     c                   write     msgsflc
     c                   write     sd000040f1
     c                   exfmt     sd000040d1
 
     c                   call      'Y2CLMSC'     pY2clmsc
     c                   eval      inputErr    = *off
 
     c                   select
     c                   when      F3_ClientDtl                                              BUG9233
     c                   eval      pRtnMsg     = 'Y2U9999'                                   BUG9233
     c                   unlock(e) sdcustxb                                                  BUG9233
     c                   when      F12_Return
     c                   unlock(e) sdcustxb
 
     c                   when      (   actnInsert
     c                             or  actnAmend  )
     c                   exsr      sInsOrAmend
 
     c                   when      actnDelete
     c                   exsr      sDelete
     c                   endsl
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     c     sInsOrAmend   begsr
 
     c                   exsr      sValidate
 
     c                   if        not inputErr
     c                   exsr      loadFileFlds
 
     c                   if        actnInsert
     c                   write     sdcustxbf
 
     c                   else
     c                   update    sdcustxbf
     c                   endif
 
     c                   exsr      commitChg
 
     c                   endif
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     c     sDelete       begsr
 
     c                   if        F10_Delete
     c                   delete    sdcustxbf
 
     c                   exsr      commitChg
     c                   endif
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     c     sValidate     begsr
 
     c                   eval      inputErr    = *off
 
     c                   exsr      vEconsect
     c                   exsr      vRiskqual
     c                   exsr      vStriskrt
     c                   exsr      vLtriskrt
     c                   exsr      vCptytype
 
     c                   if        CRN002
     c                   exsr      vOwnrperc
     c                   exsr      vRelntype
     c                   endif
 
     c                   if        CRN006
     c                   exsr      vIntctype
     c                   exsr      vInsttype
     c                   exsr      vCprtyRes                                                BUG11157
     c                   endif
 
     c                   if        CRN003
     c                   exsr      vChininfl
     c                   exsr      vHkressts
     c                   exsr      vHksectcl
     c                   endif
 
     c                   if        CRN004
     c                   exsr      vCnsectcl
     c                   exsr      vIdencode
     c                   endif
 
     c                   if        CRN005
     c                   exsr      vSgressts
     c                   exsr      vSgsectcl
     c                   endif
 
     c                   eval      inputErr    = (   invEconsect
     c                                           or  invRiskqual
     c                                           or  invStriskrt
     c                                           or  invLtriskrt
     c                                           or  invCptytype
     c                                           or  invOwnrperc
     c                                           or  invRelntype
     c                                           or  invIntctype
     c                                           or  invInsttype
     c                                           or  invChininfl
     c                                           or  invHkressts
     c                                           or  invHksectcl
     c                                           or  invCnsectcl
     c                                           or  invSgressts
     c                                           or  invSgsectcl
     c                                           or  invCprtyRes                            BUG11157
     c                                           or  questionMark                            BUG9233
     c                                           )
                                                                                             BUG9233
     c                   eval      questionmark = *off                                       BUG9233
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     c     vEconsect     begsr
 
      ** Check if ? entered for Economic Sector                                              BUG9233
     c                   eval      QuestMarkPos = %scan(%trim('?'):#1Econsect)               BUG9233
                                                                                             BUG9233
     c                   if        QuestMarkPos <> 0                                         BUG9233
     c                   eval      QuestionMark = *on                                        BUG9233
     c                   call      'RN009001S'                          90                   BUG9233
     c                   PARM      *blanks       pRtnCod           7                         BUG9233
     c                   PARM      *blanks       pEconSect        10                         BUG9233
                                                                                             BUG9233
      ** Call to program ended in error                                                      BUG9233
     c                   if        *in90       = *ON                                         BUG9233
     c                   eval      zamsidY2u   = 'Y2U0032'                                   BUG9233
     c                   eval      zamsdaY2u   = 'RN009001S'                                 BUG9233
     c                   call      'Y2SNMGC'     pY2snmgcY2u                                 BUG9233
     c                   else                                                                BUG9233
                                                                                             BUG9233
      ** If select sucessuflly, set economic sector as selected                              BUG9233
     c                   if        pRtnCod     = *blank                                      BUG9233
     c                   eval      #1Econsect  = pEconSect                                   BUG9233
     c                   endif                                                               BUG9233
     c                   endif                                                   fi *in90=*ONBUG9233
                                                                                             BUG9233
     c                   endif                                                   FI ?Pos<>0  BUG9233
                                                                                             BUG9233
     c                   if        #1Econsect  = *blanks
     c                   eval      #1Econsect  = '9999999'
     c                   endif
 
     c                   eval      invEconsect = invNumInput(#1Econsect
     c                                                     : 10
     c                                                     : 0
     c                                                     : reFmt)
 
     c                   if        not invEconsect
     c                   eval      #1Econsect  = reFmt
 
     c                   eval      wKey10_0    = %dec(#1Econsect: 10: 0)
     c     wKey10_0      chain     rnecscpd
     c                   if        not %found
     c                   eval      invEconsect = *on
     c                   eval      zamsid      = 'USR4055'
     c                   call      'Y2SNMGC'     pY2snmgc
     c                   endif
     c                   endif
 
     c                   endsr
 
      *****************************************************************
 
     c     vRiskqual     begsr
 
      ** Check if ? entered for Risk Qualification                                           BUG9233
     c                   eval      QuestMarkPos = %scan(%trim('?'):#1Riskqual)               BUG9233
                                                                                             BUG9233
     c                   if        QuestMarkPos <> 0                                         BUG9233
     c                   eval      QuestionMark = *on                                        BUG9233
     c                   call      'RN009002S'                          90                   BUG9233
     c                   PARM      *blanks       pRtnCod           7                         BUG9233
     c                   PARM      'GP'          pMMid             2                         BUG9233
     c                   PARM      'RNRISKQUAL'  pGroup           10                         BUG9233
     c                   PARM      *blanks       pVdta            20                         BUG9233
                                                                                             BUG9233
      ** Call to program ended in error                                                      BUG9233
     c                   if        *in90       = *ON                                         BUG9233
     c                   eval      zamsidY2u   = 'Y2U0032'                                   BUG9233
     c                   eval      zamsdaY2u   = 'RN009002S'                                 BUG9233
     c                   call      'Y2SNMGC'     pY2snmgcY2u                                 BUG9233
     c                   else                                                                BUG9233
                                                                                             BUG9233
      ** If select sucessuflly, set Risk Qualification as selected                           BUG9233
     c                   if        pRtnCod     = *blank                                      BUG9233
     c                   eval      #1Riskqual  = pVdta                                       BUG9233
     c                   endif                                                               BUG9233
     c                   endif                                                   fi *in90=*ONBUG9233
                                                                                             BUG9233
     c                   endif                                                   FI ?Pos<>0  BUG9233
                                                                                             BUG9233
     c                   if        #1Riskqual  = *blanks
     c                   eval      #1Riskqual  = '1'
     c                   endif
 
     c                   eval      invRiskqual = invNumInput(#1Riskqual
     c                                                     : 5
     c                                                     : 0
     c                                                     : reFmt)
 
     c                   if        not invRiskqual
     c                   eval      #1Riskqual  = reFmt
 
     c                   if        pdwnNotFnd(reFmt
     c                                      : 5
     c*****                                 : pdRiskqual)                                    BUG9233
     c                                      : HiRiskqual)                                    BUG9233
     c                   eval      invRiskqual = *on
     c                   eval      zamsid      = 'USR4059'
     c                   call      'Y2SNMGC'     pY2snmgc
     c                   endif
     c                   endif
 
     c                   endsr
 
      *****************************************************************
 
     c     vStriskrt     begsr
 
      ** Check if ? entered for Short Term Risk Rating                                       BUG9233
     c                   eval      QuestMarkPos = %scan(%trim('?'):#1StRiskRt)               BUG9233
                                                                                             BUG9233
     c                   if        QuestMarkPos <> 0                                         BUG9233
     c                   eval      questionMark = *on                                        BUG9233
     c                   call      'RN009003S'                          90                   BUG9233
     c                   PARM      *blanks       pRtnCod           7                         BUG9233
     c                   PARM      'Short Term'  pTerm            20                         BUG9233
     c                   PARM      *blanks       pCrdRtg           5                         BUG9233
                                                                                             BUG9233
      ** Call to program ended in error                                                      BUG9233
     c                   if        *in90       = *ON                                         BUG9233
     c                   eval      zamsidY2u   = 'Y2U0032'                                   BUG9233
     c                   eval      zamsdaY2u   = 'RN009003S'                                 BUG9233
     c                   call      'Y2SNMGC'     pY2snmgcY2u                                 BUG9233
     c                   else                                                                BUG9233
                                                                                             BUG9233
      ** If select sucessuflly, set Short Term Risk Rating as selected                       BUG9233
     c                   if        pRtnCod     =  *blank                                     BUG9233
     c                   eval      #1StRiskRt  = pCrdRtg                                     BUG9233
     c                   endif                                                               BUG9233
     c                   endif                                                   fi *in90=*ONBUG9233
                                                                                             BUG9233
     c                   endif                                                   FI ?Pos<>0  BUG9233
                                                                                             BUG9233
     c                   eval      invStriskrt = invNumInput(#1Striskrt
     c                                                     : 5
     c                                                     : 0
     c                                                     : reFmt     )
 
     c                   if        not invStriskrt
     c                   eval      #1Striskrt  = reFmt
 
     c                   eval      wKey5_0     = %dec(#1Striskrt: 5: 0)
     c     wKey5_0       chain     rnexcrpd
     c                   if        not %found
     c                   eval      invStriskrt = *on
     c                   eval      zamsid      = 'USR4056'
     c                   call      'Y2SNMGC'     pY2snmgc
     c                   endif
     c                   endif
 
     c                   endsr
 
      *****************************************************************
 
     c     vLtriskrt     begsr
 
      ** Check if ? entered for Long Term Risk Rating selection                              BUG9233
     c                   eval      QuestMarkPos = %scan(%trim('?'):#1LtRiskRt)               BUG9233
                                                                                             BUG9233
     c                   if        QuestMarkPos <> 0                                         BUG9233
     c                   eval      questionMark = *on                                        BUG9233
     c                   call      'RN009003S'                          90                   BUG9233
     c                   PARM      *blanks       pRtnCod           7                         BUG9233
     c                   PARM      'Long Term'   pTerm            20                         BUG9233
     c                   PARM      *blanks       pCrdRtg           5                         BUG9233
                                                                                             BUG9233
      ** Call to program ended in error                                                      BUG9233
     c                   if        *in90       = *ON                                         BUG9233
     c                   eval      zamsidY2u   = 'Y2U0032'                                   BUG9233
     c                   eval      zamsdaY2u   = 'RN009003S'                                 BUG9233
     c                   call      'Y2SNMGC'     pY2snmgcY2u                                 BUG9233
     c                   else                                                                BUG9233
                                                                                             BUG9233
      ** If select sucessuflly, set Long Term Risk Rating as selected                        BUG9233
     c                   if        pRtnCod     =  *blank                                     BUG9233
     c                   eval      #1LtRiskRt  = pCrdRtg                                     BUG9233
     c                   endif                                                               BUG9233
     c                   endif                                                   fi *in90=*ONBUG9233
                                                                                             BUG9233
     c                   endif                                                   FI ?Pos<>0  BUG9233
                                                                                             BUG9233
     c                   eval      invLtriskrt = invNumInput(#1Ltriskrt
     c                                                     : 5
     c                                                     : 0
     c                                                     : reFmt     )
 
     c                   if        not invLtriskrt
     c                   eval      #1Ltriskrt  = reFmt
 
     c                   eval      wKey5_0     = %dec(#1Ltriskrt: 5: 0)
     c     wKey5_0       chain     rnexcrpd
     c                   if        not %found
     c                   eval      invLtriskrt = *on
     c                   eval      zamsid      = 'USR4056'
     c                   call      'Y2SNMGC'     pY2snmgc
     c                   endif
     c                   endif
 
     c                   endsr
 
      *****************************Cptytype****************************
 
     c     vCptytype     begsr
 
      ** Check if ? entered for Counterparty Type Selection                                  BUG9233
     c                   eval      QuestMarkPos = %scan(%trim('?'):#1Cptytype)               BUG9233
                                                                                             BUG9233
     c                   if        QuestMarkPos <> 0                                         BUG9233
     c                   eval      questionMark = *on                                        BUG9233
     c                   call      'RN009004S'                          90                   BUG9233
     c                   PARM      *blanks       pRtnCod           7                         BUG9233
     c                   PARM      *blanks       pCptyType         5                         BUG9233
                                                                                             BUG9233
      ** Call to program ended in error                                                      BUG9233
     c                   if        *in90       = *ON                                         BUG9233
     c                   eval      zamsidY2u   = 'Y2U0032'                                   BUG9233
     c                   eval      zamsdaY2u   = 'RN009004S'                                 BUG9233
     c                   call      'Y2SNMGC'     pY2snmgcY2u                                 BUG9233
     c                   else                                                                BUG9233
                                                                                             BUG9233
      ** If select sucessuflly, set Counterparty Type as selected                            BUG9233
     c                   if        pRtnCod     =  *blank                                     BUG9233
     c                   eval      #1Cptytype  = pCptyType                                   BUG9233
     c                   endif                                                               BUG9233
     c                   endif                                                   fi *in90=*ONBUG9233
                                                                                             BUG9233
     c                   endif                                                   FI ?Pos<>0  BUG9233
                                                                                             BUG9233
     c                   eval      invCptytype = invNumInput(#1Cptytype
     c                                                     : 5
     c                                                     : 0
     c                                                     : reFmt     )
 
     c                   if        not invCptytype
     c                   eval      #1Cptytype  = reFmt
 
     c                   eval      wKey5_0     = %dec(#1Cptytype: 5: 0)
     c     wKey5_0       chain     rncpytpd
     c                   if        not %found
     c                   eval      invCptytype = *on
     c                   eval      zamsid      = 'USR4057'
     c                   call      'Y2SNMGC'     pY2snmgc
     c                   endif
     c                   endif
 
     c                   endsr
 
      *****************************************************************
 
     c     vOwnrperc     begsr
 
     c                   if        #1Ownrperc  = *blanks
     c                   eval      #1Ownrperc  = '100'
     c                   endif
 
     c                   eval      invOwnrperc = invNumInput(#1Ownrperc
     c                                                     : 6
     c                                                     : 2
     c                                                     : reFmt     )
 
     c                   if        not invOwnrperc
     c                   eval      #1Ownrperc  = reFmt
 
     c                   if        %dec(#1Ownrperc: 5: 2) > 100
     c                   eval      invOwnrperc = *on
     c                   eval      zamsid      = 'USR4053'
     c                   call      'Y2SNMGC'     pY2snmgc
     c                   endif
     c                   endif
 
     c                   endsr
 
      *****************************************************************
 
     c     vRelntype     begsr
 
      ** Check if ? entered for Relationship type                                            BUG9233
     c                   eval      QuestMarkPos = %scan(%trim('?'):#1Relntype)               BUG9233
                                                                                             BUG9233
     c                   if        QuestMarkPos <> 0                                         BUG9233
     c                   eval      QuestionMark = *on                                        BUG9233
     c                   call      'RN009002S'                          90                   BUG9233
     c                   PARM      *blanks       pRtnCod           7                         BUG9233
     c                   PARM      'GP'          pMMid             2                         BUG9233
     c                   PARM      'RNRELNTYPE'  pGroup           10                         BUG9233
     c                   PARM      *blanks       pVdta            20                         BUG9233
                                                                                             BUG9233
      ** Call to program ended in error                                                      BUG9233
     c                   if        *in90       = *ON                                         BUG9233
     c                   eval      zamsidY2u   = 'Y2U0032'                                   BUG9233
     c                   eval      zamsdaY2u   = 'RN009002S'                                 BUG9233
     c                   call      'Y2SNMGC'     pY2snmgcY2u                                 BUG9233
     c                   else                                                                BUG9233
                                                                                             BUG9233
      ** If select sucessuflly, set Relationship type as selected                            BUG9233
     c                   if        pRtnCod     = *blank                                      BUG9233
     c                   eval      #1Relntype  = pVdta                                       BUG9233
     c                   endif                                                               BUG9233
     c                   endif                                                   fi *in90=*ONBUG9233
                                                                                             BUG9233
     c                   endif                                                   FI ?Pos<>0  BUG9233
                                                                                             BUG9233
     c                   eval      invRelntype = invNumInput(#1Relntype
     c                                                     : 5
     c                                                     : 0
     c                                                     : reFmt     )
 
     c                   if        not invRelntype
     c                   eval      #1Relntype  = reFmt
 
     c                   if        pdwnNotFnd(reFmt
     c                                      : 5
     c*****                                 : pdRelntype)                                    BUG9233
     c                                      : HiRelntype)                                    BUG9233
     c                   eval      invRelntype = *on
     c                   eval      zamsid      = 'USR4063'
     c                   call      'Y2SNMGC'     pY2snmgc
     c                   endif
     c                   endif
 
     c                   endsr
 
      *****************************************************************
 
     c     vIntctype     begsr
 
      ** Check if ? entered for Internal Counterparty Type Selection                         BUG9233
     c                   eval      QuestMarkPos = %scan(%trim('?'):#1Intctype)               BUG9233
                                                                                             BUG9233
     c                   if        QuestMarkPos <> 0                                         BUG9233
     c                   eval      questionMark = *on                                        BUG9233
     c                   call      'RN009005S'                          90                   BUG9233
     c                   PARM      *blanks       pRtnCod           7                         BUG9233
     c                   PARM      *blanks       pIntctype         5                         BUG9233
                                                                                             BUG9233
      ** Call to program ended in error                                                      BUG9233
     c                   if        *in90       = *ON                                         BUG9233
     c                   eval      zamsidY2u   = 'Y2U0032'                                   BUG9233
     c                   eval      zamsdaY2u   = 'RN009005S'                                 BUG9233
     c                   call      'Y2SNMGC'     pY2snmgcY2u                                 BUG9233
     c                   else                                                                BUG9233
                                                                                             BUG9233
      ** If select sucessuflly, set Internal Counterparty Type as selected                   BUG9233
     c                   if        pRtnCod     =  *blank                                     BUG9233
     c                   eval      #1Intctype  = pIntctype                                   BUG9233
     c                   endif                                                               BUG9233
     c                   endif                                                   fi *in90=*ONBUG9233
                                                                                             BUG9233
     c                   endif                                                   FI ?Pos<>0  BUG9233
                                                                                             BUG9233
     c                   eval      invIntctype = invNumInput(#1Intctype
     c                                                     : 5
     c                                                     : 0
     c                                                     : reFmt     )
 
     c                   if        not invIntctype
     c                   eval      #1Intctype  = reFmt
 
     c                   eval      wKey5_0     = %dec(#1Intctype: 5: 0)
     c     wKey5_0       chain     rnicptpd
     c                   if        not %found
     c                   eval      invIntctype = *on
     c                   eval      zamsid      = 'USR4058'
     c                   call      'Y2SNMGC'     pY2snmgc
     c                   endif
     c                   endif
 
     c                   endsr
 
      *****************************************************************
 
     c     vInsttype     begsr
 
      ** Check if ? entered for Institution type                                             BUG9233
     c                   eval      QuestMarkPos = %scan(%trim('?'):#1Insttype)               BUG9233
                                                                                             BUG9233
     c                   if        QuestMarkPos <> 0                                         BUG9233
     c                   eval      QuestionMark = *on                                        BUG9233
     c                   call      'RN009002S'                          90                   BUG9233
     c                   PARM      *blanks       pRtnCod           7                         BUG9233
     c                   PARM      'GP'          pMMid             2                         BUG9233
     c                   PARM      'RNINSTTYPE'  pGroup           10                         BUG9233
     c                   PARM      *blanks       pVdta            20                         BUG9233
                                                                                             BUG9233
      ** Call to program ended in error                                                      BUG9233
     c                   if        *in90       = *ON                                         BUG9233
     c                   eval      zamsidY2u   = 'Y2U0032'                                   BUG9233
     c                   eval      zamsdaY2u   = 'RN009002S'                                 BUG9233
     c                   call      'Y2SNMGC'     pY2snmgcY2u                                 BUG9233
     c                   else                                                                BUG9233
                                                                                             BUG9233
      ***If*select*sucessuflly,*set*Risk*Qualification*as*selected*****             BUG9233 BUG11157
      ** If select sucessuflly, set Institution Type as selected                            BUG11157
     c                   if        pRtnCod     = *blank                                      BUG9233
     c                   eval      #1Insttype  = pVdta                                       BUG9233
     c                   endif                                                               BUG9233
     c                   endif                                                   fi *in90=*ONBUG9233
                                                                                             BUG9233
     c                   endif                                                   FI ?Pos<>0  BUG9233
                                                                                             BUG9233
     c                   eval      invInsttype = invNumInput(#1Insttype
     c                                                     : 10
     c                                                     : 0
     c                                                     : reFmt     )
 
     c                   if        not invInsttype
     c                   eval      #1Insttype  = reFmt
 
     c                   if        pdwnNotFnd(reFmt
     c                                      : 10
     c*****                                 : pdInsttype)                                    BUG9233
     c                                      : HiInsttype)                                    BUG9233
     c                   eval      invInsttype = *on
     c                   eval      zamsid      = 'USR4065'
     c                   call      'Y2SNMGC'     pY2snmgc
     c                   endif
     c                   endif
 
     c                   endsr
 
      *****************************************************************                     BUG11157
 
     c     vCprtyRes     begsr                                                              BUG11157
 
     c                   eval      invCprtyRes = *off                                       BUG11157
 
      ** Check if ? entered for Counterparty Residence selecton                             BUG11157
     c                   eval      QuestMarkPos = %scan(%trim('?'):#1CprtyRes)              BUG11157
                                                                                            BUG11157
     c                   if        QuestMarkPos <> 0                                        BUG11157
     c                   eval      questionMark = *on                                       BUG11157
     c                   call      'RN009007S'                          90                  BUG11157
     c                   PARM      *blanks       pRtnCod           7                        BUG11157
     c                   PARM      *blanks       pCprtyRes         2                        BUG11157
                                                                                            BUG11157
      ** Call to program ended in error                                                     BUG11157
     c                   if        *in90       = *ON                                        BUG11157
     c                   eval      zamsidY2u   = 'Y2U0032'                                  BUG11157
     c                   eval      zamsdaY2u   = 'RN009007S'                                BUG11157
     c                   call      'Y2SNMGC'     pY2snmgcY2u                                BUG11157
     c                   else                                                               BUG11157
                                                                                            BUG11157
      ** If select sucessuflly, set Counterpartu Residence as selected                      BUG11157
     c                   if        pRtnCod     =  *blank                                    BUG11157
     c                   eval      #1CprtyRes  = pCprtyRes                                  BUG11157
     c                   endif                                                              BUG11157
     c                   endif                                                   fi*in90=*ONBUG11157
                                                                                            BUG11157
     c                   endif                                                   FI ?Pos<>0 BUG11157
                                                                                            BUG11157
     c                   if        #1CprtyRes  = *blanks                                    BUG11157
     c                   eval      #1CprtyRes  = 'ZZ'                                       BUG11157
     c                   endif                                                              BUG11157
                                                                                            BUG11157
     c     #1CprtyRes    chain     rnctyupd                                                 BUG11157
     c                   if        not %found                                               BUG11157
     c                   eval      invCprtyRes = *on                                        BUG11157
     c                   eval      zamsid      = 'USR4066'                                  BUG11157
     c                   call      'Y2SNMGC'     pY2snmgc                                   BUG11157
     c                   endif                                                              BUG11157
                                                                                            BUG11157
     c                   endsr                                                              BUG11157
 
      *****************************************************************
 
     c     vChininfl     begsr
 
      ** Check if ? entered for Chinese influence                                            BUG9233
     c                   eval      QuestMarkPos = %scan(%trim('?'):#1Chininfl)               BUG9233
                                                                                             BUG9233
     c                   if        QuestMarkPos <> 0                                         BUG9233
     c                   eval      QuestionMark = *on                                        BUG9233
     c                   call      'RN009002S'                          90                   BUG9233
     c                   PARM      *blanks       pRtnCod           7                         BUG9233
     c                   PARM      'GP'          pMMid             2                         BUG9233
     c                   PARM      'RNCHININFL'  pGroup           10                         BUG9233
     c                   PARM      *blanks       pVdta            20                         BUG9233
                                                                                             BUG9233
      ** Call to program ended in error                                                      BUG9233
     c                   if        *in90       = *ON                                         BUG9233
     c                   eval      zamsidY2u   = 'Y2U0032'                                   BUG9233
     c                   eval      zamsdaY2u   = 'RN009002S'                                 BUG9233
     c                   call      'Y2SNMGC'     pY2snmgcY2u                                 BUG9233
     c                   else                                                                BUG9233
                                                                                             BUG9233
      ** If select sucessuflly, set Risk Qualification as selected                           BUG9233
     c                   if        pRtnCod     = *blank                                      BUG9233
     c                   eval      #1Chininfl  = pVdta                                       BUG9233
     c                   endif                                                               BUG9233
     c                   endif                                                   fi *in90=*ONBUG9233
                                                                                             BUG9233
     c                   endif                                                   FI ?Pos<>0  BUG9233
                                                                                             BUG9233
     c                   eval      invChininfl = invNumInput(#1Chininfl
     c                                                     : 5
     c                                                     : 0
     c                                                     : reFmt     )
 
     c                   if        not invChininfl
     c                   eval      #1Chininfl  = reFmt
 
     c                   if        pdwnNotFnd(reFmt
     c                                      : 5
     c*****                                 : pdChininfl)                                    BUG9233
     c                                      : HiChininfl)                                    BUG9233
     c                   eval      invChininfl = *on
     c                   eval      zamsid      = 'USR4060'
     c                   call      'Y2SNMGC'     pY2snmgc
     c                   endif
     c                   endif
 
     c                   endsr
 
      *****************************************************************
 
     c     vHkressts     begsr
 
      ** Check if ? entered for Hong Kong Residence Status                                   BUG9233
     c                   eval      QuestMarkPos = %scan(%trim('?'):#1Hkressts)               BUG9233
                                                                                             BUG9233
     c                   if        QuestMarkPos <> 0                                         BUG9233
     c                   eval      QuestionMark = *on                                        BUG9233
     c                   call      'RN009002S'                          90                   BUG9233
     c                   PARM      *blanks       pRtnCod           7                         BUG9233
     c                   PARM      'GP'          pMMid             2                         BUG9233
     c                   PARM      'RNHKRESSTS'  pGroup           10                         BUG9233
     c                   PARM      *blanks       pVdta            20                         BUG9233
                                                                                             BUG9233
      ** Call to program ended in error                                                      BUG9233
     c                   if        *in90       = *ON                                         BUG9233
     c                   eval      zamsidY2u   = 'Y2U0032'                                   BUG9233
     c                   eval      zamsdaY2u   = 'RN009002S'                                 BUG9233
     c                   call      'Y2SNMGC'     pY2snmgcY2u                                 BUG9233
     c                   else                                                                BUG9233
                                                                                             BUG9233
      ** If select sucessuflly, set Risk Qualification as selected                           BUG9233
     c                   if        pRtnCod     = *blank                                      BUG9233
     c                   eval      #1Hkressts  = pVdta                                       BUG9233
     c                   endif                                                               BUG9233
     c                   endif                                                   fi *in90=*ONBUG9233
                                                                                             BUG9233
     c                   endif                                                   FI ?Pos<>0  BUG9233
                                                                                             BUG9233
     c                   eval      invHkressts = invNumInput(#1Hkressts
     c                                                     : 5
     c                                                     : 0
     c                                                     : reFmt     )
 
     c                   if        not invHkressts
     c                   eval      #1Hkressts  = reFmt
 
     c                   if        pdwnNotFnd(reFmt
     c                                      : 5
     c*****                                 : pdHkressts)                                    BUG9233
     c                                      : HiHkressts)                                    BUG9233
     c                   eval      invHkressts = *on
     c                   eval      zamsid      = 'USR4061'
     c                   call      'Y2SNMGC'     pY2snmgc
     c                   endif
     c                   endif
 
     c                   endsr
 
      *****************************************************************
 
     c     vHksectcl     begsr
 
      ** Check if ? entered for sector class selection                                       BUG9233
     c                   eval      QuestMarkPos = %scan(%trim('?'):#1Hksectcl)               BUG9233
                                                                                             BUG9233
     c                   if        QuestMarkPos <> 0                                         BUG9233
     c                   eval      questionMark = *on                                        BUG9233
     c                   call      'RN009006S'                          90                   BUG9233
     c                   PARM      *blanks       pRtnCod           7                         BUG9233
     c                   PARM      'Hong Kong'   pRegion          20                         BUG9233
     c                   PARM      *blanks       pSectCl          10                         BUG9233
                                                                                             BUG9233
      ** Call to program ended in error                                                      BUG9233
     c                   if        *in90       = *ON                                         BUG9233
     c                   eval      zamsidY2u   = 'Y2U0032'                                   BUG9233
     c                   eval      zamsdaY2u   = 'RN009006S'                                 BUG9233
     c                   call      'Y2SNMGC'     pY2snmgcY2u                                 BUG9233
     c                   else                                                                BUG9233
                                                                                             BUG9233
      ** If select sucessuflly, set HK sector class as selected                              BUG9233
     c                   if        pRtnCod     =  *blank                                     BUG9233
     c                   eval      #1Hksectcl  = pSectCl                                     BUG9233
     c                   endif                                                               BUG9233
     c                   endif                                                   fi *in90=*ONBUG9233
                                                                                             BUG9233
     c                   endif                                                   FI ?Pos<>0  BUG9233
                                                                                             BUG9233
     c                   eval      invHksectcl = invNumInput(#1Hksectcl
     c                                                     : 10
     c                                                     : 0
     c                                                     : reFmt     )
 
     c                   if        not invHksectcl
     c                   eval      #1Hksectcl  = reFmt
 
     c                   eval      wKey10_0    = %dec(#1Hksectcl: 10: 0)
     c     wKey10_0      chain     rnsectpd
     c                   if        not %found
     c                   eval      invHksectcl = *on
     c                   eval      zamsid      = 'USR4064'
     c                   call      'Y2SNMGC'     pY2snmgc
     c                   endif
     c                   endif
 
     c                   endsr
 
      *****************************************************************
 
     c     vCnsectcl     begsr
 
      ** Check if ? entered for sector class selection                                       BUG8233
     c                   eval      QuestMarkPos = %scan(%trim('?'):#1Cnsectcl)               BUG9233
                                                                                             BUG9233
     c                   if        QuestMarkPos <> 0                                         BUG9233
     c                   eval      questionMark = *on                                        BUG9233
     c                   call      'RN009006S'                                               BUG9233
     c                   PARM      *blanks       pRtnCod           7                         BUG9233
     c                   PARM      'China'       pRegion          20                         BUG9233
     c                   PARM      *blanks       pSectCl          10                         BUG9233
                                                                                             BUG9233
      ** Call to program ended in error                                                      BUG9233
     c                   if        *in90       = *ON                                         BUG9233
     c                   eval      zamsidY2u   = 'Y2U0032'                                   BUG9233
     c                   eval      zamsdaY2u   = 'RN009006S'                                 BUG9233
     c                   call      'Y2SNMGC'     pY2snmgcY2u                                 BUG9233
     c                   else                                                                BUG9233
                                                                                             BUG9233
      ** If select sucessuflly, set China sector class as selected                           BUG9233
     c                   if        pRtnCod     =  *blank                                     BUG9233
     c                   eval      #1Cnsectcl  = pSectCl                                     BUG9233
     c                   endif                                                               BUG9233
     c                   endif                                                   fi *in90=*ONBUG9233
                                                                                             BUG9233
     c                   endif                                                   FI ?Pos<>0  BUG9233
                                                                                             BUG9233
     c                   eval      invCnsectcl = invNumInput(#1Cnsectcl
     c                                                     : 10
     c                                                     : 0
     c                                                     : reFmt     )
 
     c                   if        not invCnsectcl
     c                   eval      #1Cnsectcl  = reFmt
 
     c                   eval      wKey10_0    = %dec(#1Cnsectcl: 10: 0)
     c     wKey10_0      chain     rnsectpd
     c                   if        not %found
     c                   eval      invCnsectcl = *on
     c                   eval      zamsid      = 'USR4064'
     c                   call      'Y2SNMGC'     pY2snmgc
     c                   endif
     c                   endif
 
     c                   endsr
 
      *****************************************************************
 
     c     vIdencode     begsr
      ** No validation is needed.                                                            BUG9233
     c                   endsr
 
      *****************************************************************
 
     c     vSgressts     begsr
 
      ** Check if ? entered for Singapore residence status                                   BUG9233
     c                   eval      QuestMarkPos = %scan(%trim('?'):#1Sgressts)               BUG9233
                                                                                             BUG9233
     c                   if        QuestMarkPos <> 0                                         BUG9233
     c                   eval      QuestionMark = *on                                        BUG9233
     c                   call      'RN009002S'                          90                   BUG9233
     c                   PARM      *blanks       pRtnCod           7                         BUG9233
     c                   PARM      'GP'          pMMid             2                         BUG9233
     c                   PARM      'RNSGRESSTS'  pGroup           10                         BUG9233
     c                   PARM      *blanks       pVdta            20                         BUG9233
                                                                                             BUG9233
      ** Call to program ended in error                                                      BUG9233
     c                   if        *in90       = *ON                                         BUG9233
     c                   eval      zamsidY2u   = 'Y2U0032'                                   BUG9233
     c                   eval      zamsdaY2u   = 'RN009002S'                                 BUG9233
     c                   call      'Y2SNMGC'     pY2snmgcY2u                                 BUG9233
     c                   else                                                                BUG9233
                                                                                             BUG9233
      ** If select sucessuflly, set Risk Qualification as selected                           BUG9233
     c                   if        pRtnCod     = *blank                                      BUG9233
     c                   eval      #1Sgressts  = pVdta                                       BUG9233
     c                   endif                                                               BUG9233
     c                   endif                                                   fi *in90=*ONBUG9233
                                                                                             BUG9233
     c                   endif                                                   FI ?Pos<>0  BUG9233
                                                                                             BUG9233
     c                   eval      invSgressts = invNumInput(#1Sgressts
     c                                                     : 5
     c                                                     : 0
     c                                                     : reFmt     )
 
     c                   if        not invSgressts
     c                   eval      #1Sgressts  = reFmt
 
     c                   if        pdwnNotFnd(reFmt
     c                                      : 5
     c*****                                 : pdSgressts)                                    BUG9233
     c                                      : HiSgressts)                                    BUG9233
     c                   eval      invSgressts = *on
     c                   eval      zamsid      = 'USR4061'
     c                   call      'Y2SNMGC'     pY2snmgc
     c                   endif
     c                   endif
 
     c                   endsr
 
      *****************************************************************
 
     c     vSgsectcl     begsr
 
      ** Check if ? entered for sector class selection                                       BUG9233
     c                   eval      QuestMarkPos = %scan(%trim('?'):#1Sgsectcl)               BUG9233
                                                                                             BUG9233
     c                   if        QuestMarkPos <> 0                                         BUG9233
     c                   eval      questionMark = *on                                        BUG9233
     c                   call      'RN009006S'                          90                   BUG9233
     c                   PARM      *blanks       pRtnCod           7                         BUG9233
     c                   PARM      'Singapore'   pRegion          20                         BUG9233
     c                   PARM      *blanks       pSectCl          10                         BUG9233
                                                                                             BUG9233
      ** Call to program ended in error                                                      BUG9233
     c                   if        *in90       = *ON                                         BUG9233
     c                   eval      zamsidY2u   = 'Y2U0032'                                   BUG9233
     c                   eval      zamsdaY2u   = 'RN009006S'                                 BUG9233
     c                   call      'Y2SNMGC'     pY2snmgcY2u                                 BUG9233
     c                   else                                                                BUG9233
                                                                                             BUG9233
      ** If select sucessuflly, set Singapore Sector Class as selected.                      BUG9233
     c                   if        pRtnCod     =  *blank                                     BUG9233
     c                   eval      #1Sgsectcl  = pSectCl                                     BUG9233
     c                   endif                                                               BUG9233
     c                   endif                                                   fi *in90=*ONBUG9233
                                                                                             BUG9233
     c                   endif                                                   FI ?Pos<>0  BUG9233
                                                                                             BUG9233
     c                   eval      invSgsectcl = invNumInput(#1Sgsectcl
     c                                                     : 10
     c                                                     : 0
     c                                                     : reFmt     )
 
     c                   if        not invSgsectcl
     c                   eval      #1Sgsectcl  = reFmt
 
     c                   eval      wKey10_0    = %dec(#1Sgsectcl: 10: 0)
     c     wKey10_0      chain     rnsectpd
     c                   if        not %found
     c                   eval      invSgsectcl = *on
     c                   eval      zamsid      = 'USR4064'
     c                   call      'Y2SNMGC'     pY2snmgc
     c                   endif
     c                   endif
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     c     loadFileFlds  begsr
 
     c                   eval      bbcust      = #1Cust
     c                   eval      Econsect    = %dec(#1Econsect: 10: 0)
     c                   eval      Riskqual    = %dec(#1Riskqual:  5: 0)
     c                   eval      Striskrt    = %dec(#1Striskrt:  5: 0)
     c                   eval      Ltriskrt    = %dec(#1Ltriskrt:  5: 0)
     c                   eval      Cptytype    = %dec(#1Cptytype:  5: 0)
 
     c                   if        CRN002
     c                   eval      Ownrperc    = %dec(#1Ownrperc:  5: 2)
     c                   eval      Relntype    = %dec(#1Relntype:  5: 0)
     c                   endif
 
     c                   if        CRN006
     c                   eval      Intctype    = %dec(#1Intctype:  5: 0)
     c                   eval      Insttype    = %dec(#1Insttype: 10: 0)
     c                   eval      CprtyRes    = #1CprtyRes                                 BUG11157
     c                   endif
 
     c                   if        CRN003
     c                   eval      Chininfl    = %dec(#1Chininfl:  5: 0)
     c                   eval      Hkressts    = %dec(#1Hkressts:  5: 0)
     c                   eval      Hksectcl    = %dec(#1Hksectcl: 10: 0)
     c                   endif
 
     c                   if        CRN004
     c                   eval      Cnsectcl    = %dec(#1Cnsectcl: 10: 0)
     c                   eval      Idencode    = #1Idencode
     c                   endif
 
     c                   if        CRN005
     c                   eval      Sgressts    = %dec(#1Sgressts:  5: 0)
     c                   eval      Sgsectcl    = %dec(#1Sgsectcl: 10: 0)
     c                   endif
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     c     initial       begsr
 
      * Special case action parameter 'V' means 'verify for delete'.
      * I.e. if a record exists return message accordingly.
     c                   if        pAction     = 'V'
     c     #1Cust        setll     sdcustxb
     c                   if        %equal
     c                   eval      pRtnMsg     = 'USR4050'
     c                   endif
     c                   exsr      closedown
     c                   endif
 
      * Other actions relate to maintenance or enquiry.
     c                   eval      actnInsert  = *off
     c                   eval      actnAmend   = *off
     c                   eval      actnDelete  = *off
     c                   eval      actnEnquiry = *off
 
     c                   if        (   pAction = 'I'
     c                             or  pAction = 'A'
     c                             or  pAction = 'D' )
     c                   monitor
     c     #1Cust        chain     sdcustxb
     c                   on-error  rcdLocked
     c                   call      'Y2CLMSC'     pY2clmsc
     c                   eval      zamsid      = 'USR4054'
     c                   call      'Y2SNMGC'     pY2snmgc
     c                   eval      pAction     = 'E'
     c                   endmon
 
     c                   else
     c                   eval      pAction     = 'E'
     c                   endif
 
     c                   if        pAction     = 'E'
     c     #1Cust        chain(n)  sdcustxb
     c                   endif
 
      * Set mode based on action parameter.
 
     c                   select
 
     c                   when      (   pAction = 'I'
     c                             or  pAction = 'A' )
     c                   if        %found
     c                   eval      actnAmend   = *on
     c                   else
     c                   eval      actnInsert  = *on
     c                   endif
 
     c                   when      pAction = 'E'
     c                             or  (   pAction = 'D'
     c                                 and not %found    )
     c                   eval      actnEnquiry = *on
     c                   if        not %found
     c                   eval      zamsid      = 'USR4051'
     c                   call      'Y2SNMGC'     pY2snmgc
     c                   endif
 
     c                   when      pAction     = 'D'
     c                   eval      actnDelete  = *on
 
     c                   endsl
 
      * Protect input fields in enquiry or delete modes.
     c                   eval      protectFlds = (   actnEnquiry
     c                                           or  actnDelete  )
 
     c                   if        %found
     c                   eval      #1Econsect  = %editc(Econsect: '3')
     c                   eval      #1Riskqual  = %editc(Riskqual: '3')
     c                   eval      #1Striskrt  = %editc(Striskrt: '3')
     c                   eval      #1Ltriskrt  = %editc(Ltriskrt: '3')
     c                   eval      #1Cptytype  = %editc(Cptytype: '3')
     c                   eval      #1Ownrperc  = %editc(Ownrperc: '3')
     c                   eval      #1Relntype  = %editc(Relntype: '3')
     c                   eval      #1Intctype  = %editc(Intctype: '3')
     c                   eval      #1Insttype  = %editc(Insttype: '3')
     c                   eval      #1CprtyRes  = CprtyRes                                   BUG11157
     c                   eval      #1Chininfl  = %editc(Chininfl: '3')
     c                   eval      #1Hkressts  = %editc(Hkressts: '3')
     c                   eval      #1Hksectcl  = %editc(Hksectcl: '3')
     c                   eval      #1Cnsectcl  = %editc(Cnsectcl: '3')
     c                   eval      #1Idencode  = Idencode
     c                   eval      #1Sgressts  = %editc(Sgressts: '3')
     c                   eval      #1Sgsectcl  = %editc(Sgsectcl: '3')
 
     c                   else
     c                   eval      #1Econsect  = *blanks
     c                   eval      #1Riskqual  = *blanks
     c                   eval      #1Striskrt  = *blanks
     c                   eval      #1Ltriskrt  = *blanks
     c                   eval      #1Cptytype  = *blanks
     c                   eval      #1Ownrperc  = *blanks
     c                   eval      #1Relntype  = *blanks
     c                   eval      #1Intctype  = *blanks
     c                   eval      #1Insttype  = *blanks
     c                   eval      #1CprtyRes  = *blanks                                    BUG11157
     c                   eval      #1Chininfl  = *blanks
     c                   eval      #1Hkressts  = *blanks
     c                   eval      #1Hksectcl  = *blanks
     c                   eval      #1Cnsectcl  = *blanks
     c                   eval      #1Sgressts  = *blanks
     c                   eval      #1Sgsectcl  = *blanks
     c                   endif
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     c     commitChg     begsr
 
     c                   commit
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     c     closedown     begsr
 
     c                   callp(e)  qCmdExc(cmdDltovr : lenDltovr)
 
     c                   eval      *inlr       = *on
     c                   return
 
     c                   endsr
 
      *********************************************************************
      /EJECT                                                                                 BUG9233
      *********************************************************************                  BUG9233
                                                                                             BUG9233
     c     GetHeaderId   begsr                                                               BUG9233
                                                                                             BUG9233
     c     Kpdwhl0       chain     gppdwhl0                                                  BUG9233
     c                   if        not %found                                                BUG9233
     c                   exsr      *pssr                                                     BUG9233
     c                   endif                                                               BUG9233
                                                                                             BUG9233
     c                   endsr                                                               BUG9233
                                                                                             BUG9233
      *********************************************************************                  BUG9233
      /EJECT
      *********************************************************************
 
     c     *inzsr        begsr
 
     c                   in        rundat
 
      ** Check for CRN... features.
     c                   callb     'AOSARDR0'
     c                   parm      *blanks       pRtnCod
     c                   parm      '*VERIFY'     pOption
     c                   parm      'CRN002'      pSar
 
     c                   if        pRtnCod     = *blanks
     c                   eval      CRN002      = *on
 
     c                   elseif    pRtnCod     = '*NRF'
     c                   eval      CRN002      = *off
 
     c                   else
     c                   exsr      *pssr
     c                   endif
 
     c                   if        CRN002
     c                   callb     'AOSARDR0'
     c                   parm      *blanks       pRtnCod
     c                   parm      '*VERIFY'     pOption
     c                   parm      'CRN003'      pSar
 
     c                   if        pRtnCod     = *blanks
     c                   eval      CRN003      = *on
 
     c                   elseif    pRtnCod     = '*NRF'
     c                   eval      CRN003      = *off
 
     c                   else
     c                   exsr      *pssr
     c                   endif
 
     c                   callb     'AOSARDR0'
     c                   parm      *blanks       pRtnCod
     c                   parm      '*VERIFY'     pOption
     c                   parm      'CRN004'      pSar
 
     c                   if        pRtnCod     = *blanks
     c                   eval      CRN004      = *on
 
     c                   elseif    pRtnCod     = '*NRF'
     c                   eval      CRN004      = *off
 
     c                   else
     c                   exsr      *pssr
     c                   endif
 
     c                   callb     'AOSARDR0'
     c                   parm      *blanks       pRtnCod
     c                   parm      '*VERIFY'     pOption
     c                   parm      'CRN005'      pSar
 
     c                   if        pRtnCod     = *blanks
     c                   eval      CRN005      = *on
 
     c                   elseif    pRtnCod     = '*NRF'
     c                   eval      CRN005      = *off
 
     c                   else
     c                   exsr      *pssr
     c                   endif
     c                   endif
 
     c                   callb     'AOSARDR0'
     c                   parm      *blanks       pRtnCod
     c                   parm      '*VERIFY'     pOption
     c                   parm      'CRN006'      pSar
 
     c                   if        pRtnCod     = *blanks
     c                   eval      CRN006      = *on
 
     c                   elseif    pRtnCod     = '*NRF'
     c                   eval      CRN006      = *off
 
     c                   else
     c                   exsr      *pssr
     c                   endif
 
     c                   call      'Y2CLMSC'     pY2clmsc
 
     c                   if        not %open(sdcustxb)
     c                   callp     qCmdExc(cmdOvrdbf : lenOvrdbf)
     c                   open      sdcustxb
     c                   endif
 
      ** Get header ids for groups from file gppdwhl0:                                       BUG9233
     c                   open      gppdwhl0                                                  BUG9233
 
     c     Kpdwhl0       klist                                                               BUG9233
     c                   kfld                    KFldMmid          2            Module Id    BUG9233
     c                   kfld                    KFldGroup        10            Group        BUG9233
      *                                                                                      BUG9233
     c                   eval      KFldMmid   = 'GP'                                         BUG9233
                                                                                             BUG9233
      **  Risk qualification                                                                 BUG9233
     c                   eval      KFldGroup  = 'RNRISKQUAL'                                 BUG9233
     c                   exsr      GetHeaderId                                               BUG9233
     c                   eval      HiRiskqual = ghhind                                       BUG9233
 
      **  Relationship type                                                                  BUG9233
     c                   if        CRN002                                                    BUG9233
     c                   eval      KFldGroup  = 'RNRELNTYPE'                                 BUG9233
     c                   exsr      GetHeaderId                                               BUG9233
     c                   eval      HiRelntype = ghhind                                       BUG9233
     c                   endif                                                               BUG9233
 
      **  Institution tupe                                                                   BUG9233
     c                   if        CRN006                                                    BUG9233
     c                   eval      KFldGroup  = 'RNINSTTYPE'                                 BUG9233
     c                   exsr      GetHeaderId                                               BUG9233
     c                   eval      HiInsttype = ghhind                                       BUG9233
     c                   endif                                                               BUG9233
 
      **  Chinese influence                                                                  BUG9233
     c                   if        CRN003                                                    BUG9233
     c                   eval      KFldGroup  = 'RNCHININFL'                                 BUG9233
     c                   exsr      GetHeaderId                                               BUG9233
     c                   eval      HiChininfl = ghhind                                       BUG9233
 
      **  HK Residence status                                                                BUG9233
     c                   eval      KFldGroup  = 'RNHKRESSTS'                                 BUG9233
     c                   exsr      GetHeaderId                                               BUG9233
     c                   eval      HiHkressts = ghhind                                       BUG9233
     c                   endif                                                               BUG9233
 
      **  Singapore residence status                                                         BUG9233
     c                   if        CRN005                                                    BUG9233
     c                   eval      KFldGroup  = 'RNSGRESSTS'                                 BUG9233
     c                   exsr      GetHeaderId                                               BUG9233
     c                   eval      HiSgressts = ghhind                                       BUG9233
     c                   endif                                                               BUG9233
 
     c                   close     gppdwhl0                                                  BUG9233
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
 
     c     *pssr         begsr
 
     c                   if        not inPssr
     c                   eval      inPssr      = *on
     c                   rolbk(e)
     c                   dump
     c                   endif
 
     c                   eval      pRtnMsg     = '*ERROR'
     c                   eval      *inlr       = *on
     c                   return
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
 
     p invNumInput     b
 
     d                 pi              n
     d inpField                      10    options(*varsize)
     d                                     const
     d inpLen                         3u 0 const
     d maxDec                         3u 0 const
     d reFmt                         10    varying
 
     d outNumber       s             19  9
     d wNum10_0        s             10  0
     d wNum5_0         s              5  0
     d wNum5_2         s              5  2
     d invalid         s               n
 
     d invNumeric      c                   00105
     d tooLarge        c                   00103
 
      *---------------------------------------------------------------------
 
     c                   eval      invalid     = *off
 
     c                   eval      %len(reFmt) = inpLen
     c                   eval      reFmt       = %subst(inpField:1:inpLen)
     c                   if        reFmt       = *blanks
     c                   eval      reFmt       = '0'
     c                   endif
 
     c                   monitor
     c                   eval      outNumber   = %dec(reFmt: 19: 9)
 
     c                   if        (   maxDec  = 0
     c                             and outNumber <> %uns(reFmt) )
     c                   eval      invalid     = *on
     c                   endif
 
     c                   if        (   inpLen  = 6
     c                             and maxDec  = 2
     c                             and outNumber <> %dec(reFmt:  5: 2) )
     c                   eval      invalid     = *on
     c                   endif
 
     c                   on-error  invNumeric: tooLarge
     c                   eval      invalid     = *on
     c                   endmon
 
      * Send message if invalid.
     c                   if        invalid
     c                   eval      zamsid      = 'USR4052'
     c                   call      'Y2SNMGC'     pY2snmgc
 
      * otherwise reformat the valid numeric expression.
     c                   else
 
     c                   select
     c                   when      (   inpLen  = 10
     c                             and maxDec  = 0  )
     c                   eval      wNum10_0    = outNumber
     c                   eval      reFmt       = %editc(wNum10_0: '3')
 
     c                   when      (   inpLen  = 5
     c                             and maxDec  = 0  )
     c                   eval      wNum5_0     = outNumber
     c                   eval      reFmt       = %editc(wNum5_0: '3')
 
     c                   when      (   inpLen  = 6
     c                             and maxDec  = 2  )
     c                   eval      wNum5_2     = outNumber
     c                   eval      reFmt       = %editc(wNum5_2: '3')
     c                   endsl
 
     c                   endif
 
     c                   return    invalid
 
     p                 e
 
      *********************************************************************
      /EJECT
      *********************************************************************
 
     p pdwnNotFnd      b
 
     d                 pi              n
     d inpField                      10    varying
     d                                     const
     d inpLen                         3u 0 const
     d headerId                      10s 0 const
 
     d inpFldV         s             10    varying
 
      *---------------------------------------------------------------------
 
     c                   eval      %len(inpFldV) = inpLen
     c                   eval      inpFldV     = %subst(inpField:1:inpLen)
 
     c     headerId      setll     gppdwnl0
     c     headerId      reade     gppdwnl0
     c                   dow       not %eof
     c                   if        glvdta      = %trim(inpFldV)
     c                   leave
     c                   endif
     c     headerId      reade     gppdwnl0
     c                   enddo
 
     c                   return    %eof
 
     p                 e
