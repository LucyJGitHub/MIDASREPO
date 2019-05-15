     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Watch list configuration validation')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDWLCCVAL - Watch List Configuration Validation              *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD041172           Date 20Sep16               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD041172 - WLC Bulk Customer Watchlist Gap
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDMTPYL0  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D MTYPE           S              3A   DIM(20)
     D INEX            S              1A   DIM(20)
     D VMsgType        S              3A   DIM(20)
     D COMBARR         S              1A   DIM(80)
 
     D FreqValues      S              1A   DIM(13) CTDATA PERRCD(13)
     D FrqRqDayNo      S              1A   DIM(8) CTDATA PERRCD(8)
     D NUMARR          S              1A   DIM(10) CTDATA PERRCD(10)
     D NUMARR2         S              1A   DIM(11) CTDATA PERRCD(11)
 
     D WLCMDets      E DS                  EXTNAME(SDWLCMPD)
      ** Watch List Configuration Definition File
 
     D OKWLCMDets    E DS                  EXTNAME(SDEWLCMPD)
      ** Watch List Configuration Error File
 
     D ValidWLCM     E DS                  EXTNAME(SDWLCMPD)
     D                                     PREFIX(V)
     D ValWLCM                53    132
      ** Validated Watch List Configuration Details
 
      ** First DS for Access Programs, Short Data Structure                                   CSD083
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSD083
                                                                                              CSD083
      ** External DS for SAR Details                                                          CSD083
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD083
                                                                                              CSD083
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
     D A               S              3P 0
     D B               S              3P 0
     D POPTN           S              7A
     D PRTCD           S              7A
     D WPDYN           S              2P 0
     D WPDYN2          S              2A
     D TmpMsgB         S              2A
     D TmpMsg1         S              1A
     D TmpMsg2         S              1A
     D TmpMsg3         S              1A
     D WMessage        S              3A
     D WTMsgType       S              3A
     D WNumMsg         S              3S 0
     D WNumMsg2        S              3A
     D MTYPERR         S              1A
     D MTYPER          S              1A
     D INEXERR         S              1A
     D TempVar         S              4A
     D PSARD           S              6A                                                      CSD083
     D CSD083          S              1A                                                      CSD083
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
     C                   EVAL      V#1FUNC = #1FUNC
     C                   EVAL      V#1FUND = #1FUND
 
      ** Validate Data Entry Watch List Checking Applied
 
     C                   EXSR      ValEWLC
     C                   IF        #1EWLCOK = 'Y'
     C                   EVAL      V#1EWLC = #1EWLC
     C                   ENDIF
 
     C                   IF        #1FUNC <> 'MESSGENT'
     C                   IF        CSD083 = 'N'                                               CSD083
     C                             OR CSD083 = 'Y' AND #1FUNC = 'SDCUSD'                    MD041172
 
      ** Validate Periodic Watch List Checking Frequency
 
     C                   EXSR      ValPFRQ
     C                   IF        #1PFRQOK = 'Y'
     C                   EVAL      V#1PFRQ = #1PFRQ
     C                   ENDIF
 
      ** Validate Periodic Watch List Checking Day Number
 
     C                   EXSR      ValPDYN
     C                   IF        #1PDYNOK = 'Y'
     C                   EVAL      V#1PDYN = #1PDYN
     C                   ENDIF
     C                   ENDIF                                                                CSD083
 
     C                   ELSE
 
      ** Validate Message Checking - Message Type
 
     C                   EXSR      ValMTYP
 
      ** Validate Message Checking - Include/Exclude Indicator
 
     C                   EXSR      ValINEX
 
     C                   IF        MTYPErr = 'N' and INEXErr = 'N'
 
     C                   EVAL      A = 1
     C                   EVAL      B = 1
 
     C                   DOW       A <= 20
     C                   EVAL      TempVar = VMsgType(A) + INEX(A)
     C                   MOVEA     TempVar       COMBARR(B)
     C                   EVAL      A = A + 1
     C                   EVAL      B = B + 4
     C                   ENDDO
 
     C                   MOVEA     COMBARR       ValWLCM
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValEWLC - Validate Data Entry Watch List Checking Applied     *
      *                                                               *
      *****************************************************************
 
     C     ValEWLC       BEGSR
 
     C                   IF        #1EWLC = *BLANKS
     C                   IF        CSD083 = 'Y'                                               CSD083
     C                   EVAL      #1EWLC = 'Y'                                               CSD083
     C                   ELSE                                                                 CSD083
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1EWLC'
     C                   EVAL      MsgIDArr(Idx) = 'USR9641'
     C                   EVAL      #1EWLCOK = 'N'
     C                   ENDIF                                                                CSD083
     C                   ENDIF
 
     C                   IF        #1EWLC <> 'Y' and #1EWLC <> 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1EWLC'
     C                   EVAL      MsgIDArr(Idx) = 'USR9642'
     C                   EVAL      #1EWLCOK = 'N'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValPFRQ - Validate Periodic Watch List Checking Frequency     *
      *                                                               *
      *****************************************************************
 
     C     ValPFRQ       BEGSR
 
     C                   IF        #1PFRQ <> *BLANKS
 
     C     #1PFRQ        LOOKUP    FreqValues                             75
 
     C                   IF        *IN75 = *OFF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1PFRQ'
     C                   EVAL      MsgIDArr(Idx) = 'USR9603'
     C                   EVAL      #1PFRQOK = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValPDYN - Validate Periodic Watch List Checking Day Number    *
      *                                                               *
      *****************************************************************
 
     C     ValPDYN       BEGSR
 
     C                   IF        #1PDYN <> *BLANKS and #1PFRQ = *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1PDYN'
     C                   EVAL      MsgIDArr(Idx) = 'USR9604'
     C                   EVAL      #1PDYNOK = 'N'
     C                   ENDIF
 
     C                   IF        #1PDYN <> *BLANKS
     C                   MOVE      #1PDYN        WPDYN
     C                   MOVE      WPDYN         WPDYN2
 
     C                   IF        #1PDYN <> WPDYN2 or WPDYN > 31 or
     C                             WPDYN = 0
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1PDYN'
     C                   EVAL      MsgIDArr(Idx) = 'USR9605'
     C                   EVAL      #1PDYNOK = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #1PFRQOK = 'Y'
     C     #1PFRQ        LookUp    FrqRqDayNo                             75
 
     C                   IF        *IN75 = *OFF  and #1PDYN <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1PDYN'
     C                   EVAL      MsgIDArr(Idx) = 'USR9604'
     C                   EVAL      #1PDYNOK = 'N'
     C                   ENDIF
 
     C                   IF        *IN75 = *ON  and #1PDYN = *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1PDYN'
     C                   EVAL      MsgIDArr(Idx) = 'USR9604'
     C                   EVAL      #1PDYNOK = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValMTYP - Validate Message Checking - Message Type            *
      *                                                               *
      *****************************************************************
 
     C     ValMTYP       BEGSR
 
     C                   MOVE      *BLANKS       VMsgType
 
      ** Move screen field data to array
 
     C                   EVAL      A = 1
     C                   EVAL      B = 53
 
     C                   DOW       A <= 20
     C                   EVAL      MTYPE(A) = (%SUBST(WLCMDets:B:3))
     C                   EVAL      A = A + 1
     C                   EVAL      B = B + 4
     C                   ENDDO
 
     C                   EVAL      A = 1
     C                   EVAL      MTYPErr = 'N'
 
      ** Validate Message Type
 
     C                   DOW       A <= 20
 
     C                   IF        MTYPE(A) <> *BLANKS
 
     C                   EVAL      MTYPEr = 'N'
     C                   MOVE      *BLANKS       WTMsgType
     C                   MOVEA     MTYPE(A)      WMessage
     C                   MOVE      WMessage      WNumMsg
     C                   MOVE      WNumMsg       WNumMsg2
 
      ** Check if numeric
 
     C                   IF        WMessage = WNumMsg2
     C                   MOVE      WMessage      WTMsgType
 
      ** Check for generic code
 
     C                   ELSE
     C                   MOVE      'N'           MTYPErr
     C                   MOVE      WMessage      TmpMsg3
     C                   MOVEL     WMessage      TmpMsgB
     C                   MOVEL     TmpMsgB       TmpMsg1
     C                   MOVE      TmpMsgB       TmpMsg2
 
     C     TmpMsg1       LOOKUP    NUMARR                                 75
     C                   IF        *IN75 = *ON
     C     TmpMsg2       LOOKUP    NUMARR2                                75
     C                   IF        *IN75 = *ON
     C                   IF        TmpMsg3 = '*'
     C                   MOVE      WMessage      WTMsgType
     C                   ELSE
     C                   MOVE      'Y'           MTYPEr
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'Y'           MTYPEr
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'Y'           MTYPEr
     C                   ENDIF
 
     C                   ENDIF
 
      ** Check if valid Message Type
 
     C                   IF        WMessage = WNumMsg2
     C     WTMsgType     CHAIN     SDMTPYL0                           76
     C                   ENDIF
 
     C                   IF        *IN76 = *ON or MTYPEr = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDArr(Idx) = 'USR9608'
     C                   EXSR      SRSelFld
     C                   EVAL      MTYPErr = 'Y'
     C                   ELSE
 
      ** Check if unique
 
     C                   EVAL      B = 1
 
     C                   DOW       B <= 20
 
     C                   IF        VMsgType(B) = *BLANKS
     C                   EVAL      VMsgType(B) = WTMsgType
     C                   LEAVE
     C                   ELSE
     C                   IF        VMsgType(B) = WTMsgType
     C                   ADD       1             Idx
     C                   EVAL      MsgIDArr(Idx) = 'USR9609'
     C                   EXSR      SRSelFld
     C                   EVAL      MTYPErr = 'Y'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      B = B + 1
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      A = A + 1
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValINEX - Validate Message Checking - Include/Exclude Ind.    *
      *                                                               *
      *****************************************************************
 
     C     ValINEX       BEGSR
 
      ** Move screen field data to array
 
     C                   EVAL      A = 1
     C                   EVAL      B = 56
 
     C                   DOW       A <= 20
     C                   EVAL      INEX(A) = (%SUBST(WLCMDets:B:1))
     C                   EVAL      A = A + 1
     C                   EVAL      B = B + 4
     C                   ENDDO
 
     C                   EVAL      A = 1
     C                   EVAL      B = 1
     C                   EVAL      INEXErr = 'N'
 
     C                   DOW       A <= 20
 
     C                   IF        MTYPE(A) <> *BLANKS
 
     C                   IF        INEX(A) = *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDArr(Idx) = 'USR9606'
     C                   EXSR      SRSelFld2
     C                   ENDIF
 
     C                   IF        INEX(A) <> 'I' and INEX(A) <> 'E'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDArr(Idx) = 'USR9607'
     C                   EXSR      SRSelFld2
     C                   EVAL      INEXErr = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        INEX(A) <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDArr(Idx) = 'USR9606'
     C                   EXSR      SRSelFld2
     C                   EVAL      INEXErr = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      A = A + 1
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSelFld - Update Field Name Array and Error Flags            *
      *                                                               *
      *****************************************************************
 
     C     SRSelFld      BEGSR
 
     C                   SELECT
     C                   WHEN      A = 1
     C                   EVAL      FldNameArr(Idx) = '#1MT01'
     C                   EVAL      #1MT01OK = 'N'
     C                   WHEN      A = 2
     C                   EVAL      FldNameArr(Idx) = '#1MT02'
     C                   EVAL      #1MT02OK = 'N'
     C                   WHEN      A = 3
     C                   EVAL      FldNameArr(Idx) = '#1MT03'
     C                   EVAL      #1MT03OK = 'N'
     C                   WHEN      A = 4
     C                   EVAL      FldNameArr(Idx) = '#1MT04'
     C                   EVAL      #1MT04OK = 'N'
     C                   WHEN      A = 5
     C                   EVAL      FldNameArr(Idx) = '#1MT05'
     C                   EVAL      #1MT05OK = 'N'
     C                   WHEN      A = 6
     C                   EVAL      FldNameArr(Idx) = '#1MT06'
     C                   EVAL      #1MT06OK = 'N'
     C                   WHEN      A = 7
     C                   EVAL      FldNameArr(Idx) = '#1MT07'
     C                   EVAL      #1MT07OK = 'N'
     C                   WHEN      A = 8
     C                   EVAL      FldNameArr(Idx) = '#1MT08'
     C                   EVAL      #1MT08OK = 'N'
     C                   WHEN      A = 9
     C                   EVAL      FldNameArr(Idx) = '#1MT09'
     C                   EVAL      #1MT09OK = 'N'
     C                   WHEN      A = 10
     C                   EVAL      FldNameArr(Idx) = '#1MT10'
     C                   EVAL      #1MT10OK = 'N'
     C                   WHEN      A = 11
     C                   EVAL      FldNameArr(Idx) = '#1MT11'
     C                   EVAL      #1MT11OK = 'N'
     C                   WHEN      A = 12
     C                   EVAL      FldNameArr(Idx) = '#1MT12'
     C                   EVAL      #1MT12OK = 'N'
     C                   WHEN      A = 13
     C                   EVAL      FldNameArr(Idx) = '#1MT13'
     C                   EVAL      #1MT13OK = 'N'
     C                   WHEN      A = 14
     C                   EVAL      FldNameArr(Idx) = '#1MT14'
     C                   EVAL      #1MT14OK = 'N'
     C                   WHEN      A = 15
     C                   EVAL      FldNameArr(Idx) = '#1MT15'
     C                   EVAL      #1MT15OK = 'N'
     C                   WHEN      A = 16
     C                   EVAL      FldNameArr(Idx) = '#1MT16'
     C                   EVAL      #1MT16OK = 'N'
     C                   WHEN      A = 17
     C                   EVAL      FldNameArr(Idx) = '#1MT17'
     C                   EVAL      #1MT17OK = 'N'
     C                   WHEN      A = 18
     C                   EVAL      FldNameArr(Idx) = '#1MT18'
     C                   EVAL      #1MT18OK = 'N'
     C                   WHEN      A = 19
     C                   EVAL      FldNameArr(Idx) = '#1MT19'
     C                   EVAL      #1MT19OK = 'N'
     C                   WHEN      A = 20
     C                   EVAL      FldNameArr(Idx) = '#1MT20'
     C                   EVAL      #1MT20OK = 'N'
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSelFld2 - Update Field Name Array and Error Flags 2         *
      *                                                               *
      *****************************************************************
 
     C     SRSelFld2     BEGSR
 
     C                   SELECT
     C                   WHEN      A = 1
     C                   EVAL      FldNameArr(Idx) = '#1IE01'
     C                   EVAL      #1IE01OK = 'N'
     C                   WHEN      A = 2
     C                   EVAL      FldNameArr(Idx) = '#1IE02'
     C                   EVAL      #1IE02OK = 'N'
     C                   WHEN      A = 3
     C                   EVAL      FldNameArr(Idx) = '#1IE03'
     C                   EVAL      #1IE03OK = 'N'
     C                   WHEN      A = 4
     C                   EVAL      FldNameArr(Idx) = '#1IE04'
     C                   EVAL      #1IE04OK = 'N'
     C                   WHEN      A = 5
     C                   EVAL      FldNameArr(Idx) = '#1IE05'
     C                   EVAL      #1IE05OK = 'N'
     C                   WHEN      A = 6
     C                   EVAL      FldNameArr(Idx) = '#1IE06'
     C                   EVAL      #1IE06OK = 'N'
     C                   WHEN      A = 7
     C                   EVAL      FldNameArr(Idx) = '#1IE07'
     C                   EVAL      #1IE07OK = 'N'
     C                   WHEN      A = 8
     C                   EVAL      FldNameArr(Idx) = '#1IE08'
     C                   EVAL      #1IE08OK = 'N'
     C                   WHEN      A = 9
     C                   EVAL      FldNameArr(Idx) = '#1IE09'
     C                   EVAL      #1IE09OK = 'N'
     C                   WHEN      A = 10
     C                   EVAL      FldNameArr(Idx) = '#1IE10'
     C                   EVAL      #1IE10OK = 'N'
     C                   WHEN      A = 11
     C                   EVAL      FldNameArr(Idx) = '#1IE11'
     C                   EVAL      #1IE11OK = 'N'
     C                   WHEN      A = 12
     C                   EVAL      FldNameArr(Idx) = '#1IE12'
     C                   EVAL      #1IE12OK = 'N'
     C                   WHEN      A = 13
     C                   EVAL      FldNameArr(Idx) = '#1IE13'
     C                   EVAL      #1IE13OK = 'N'
     C                   WHEN      A = 14
     C                   EVAL      FldNameArr(Idx) = '#1IE14'
     C                   EVAL      #1IE14OK = 'N'
     C                   WHEN      A = 15
     C                   EVAL      FldNameArr(Idx) = '#1IE15'
     C                   EVAL      #1IE15OK = 'N'
     C                   WHEN      A = 16
     C                   EVAL      FldNameArr(Idx) = '#1IE16'
     C                   EVAL      #1IE16OK = 'N'
     C                   WHEN      A = 17
     C                   EVAL      FldNameArr(Idx) = '#1IE17'
     C                   EVAL      #1IE17OK = 'N'
     C                   WHEN      A = 18
     C                   EVAL      FldNameArr(Idx) = '#1IE18'
     C                   EVAL      #1IE18OK = 'N'
     C                   WHEN      A = 19
     C                   EVAL      FldNameArr(Idx) = '#1IE19'
     C                   EVAL      #1IE19OK = 'N'
     C                   WHEN      A = 20
     C                   EVAL      FldNameArr(Idx) = '#1IE20'
     C                   EVAL      #1IE20OK = 'N'
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset Error Information That Is Received Back     *
      *             From Each Validation Module                       *
      *                                                               *
      *****************************************************************
 
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *BLANKS
 
      ** Reset error & warning fields/message IDs/message data (arrays)
 
     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIDArr = *BLANKS
     C                   EVAL      MsgDtaArr = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Watch List Configuration Definition File
     C                   PARM                    WLCMDets
 
      ** Outputs
      ** Watch List Configuration Error File
     C                   PARM                    OKWLCMDets
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Valid Watch List Configuration Definition File
     C                   PARM                    ValidWLCM
 
     C                   EVAL      DBPGM = 'SDWLCCVAL'
 
      *                                                                                       CSD083
      ** Check if CSD083 is installed                                                         CSD083
      *                                                                                       CSD083
     C                   CALL      'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRTCD                                        CSD083
     C                   PARM      '*VERIFY'     POPTN                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRTCD = *BLANKS                                            CSD083
     C                   EVAL      CSD083 = 'Y'                                               CSD083
     C                   ELSE                                                                 CSD083
     C                   EVAL      CSD083 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
** CPY@
(c) Finastra International Limited 2002
** FreqValues
DWFSMRTQXYLBA
** FrqRqDayNo
MRTQXYLB
** NUMARR
0123456789
** NUMARR2
0123456789*
