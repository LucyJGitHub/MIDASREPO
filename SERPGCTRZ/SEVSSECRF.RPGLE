     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate security references')                *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSSECRF - Validate Security References                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD000091           Date 15May13               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 210378             Date 16Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 14May01               *
      *                 CAP060             Date 14May01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  210378 - Show warning message instead of blocking message    *
      *           if security reference already exists for an other   *
      *           security (like ISIN code)                           *
      *  CSD006 - Market Data Feeds (recompile)                       *
      *  CAP060 - Midas APIs, Security Prices Full API (recompile)    *
      *  CAP137 - Conversion of SE Securitiy inputs into modular      *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Securities by EUCLID Code
     FSECTE     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SECTYDF:SECTYDL5)
      *
      ** Securities by depot reference 2
     FSECT2     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SECTYDF:SECTYDL6)
      *
      ** Securities by depot reference 3
     FSECT3     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SECTYDF:SECTYDL7)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     D NwSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Securities screen 2 error indicators
     D SEESEC2       E DS                  EXTNAME(SEESEC2PD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
     D WIx             S              3P 0                                                    210378
      *
      ** Work variables
     D WDASR           S             12A
     D WDCSR           S             12A
     D WDDSR           S             12A

     D*PSDC1****       S              6S 0                                                    CSD027
     D*PSDC2****       S              6S 0                                                    CSD027
     D*PSDC3****       S              6S 0                                                    CSD027
     D PSDC1           S              6A                                                      CSD027
     D PSDC2           S              6A                                                      CSD027
     D PSDC3           S              6A                                                      CSD027
     D WFound          S              1A
     D CSE011          S              1A
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091

      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialise work variables.
     C                   EVAL      IDx = 0
     C                   EVAL      WIx = 0                                                    210378
      *
      ** Validate depot security references
      *
     C                   EXSR      SRValSecRef
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C**********         IF        OKDASR = 'N' OR                                            210378
     C**********                   OKDCSR = 'N' OR                                            210378
     C**********                   OKDDSR = 'N'                                               210378
     C                   IF        OKDASR <> 'Y' OR                                           210378
     C                             OKDCSR <> 'Y' OR                                           210378
     C                             OKDDSR <> 'Y'                                              210378
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF

     C                   IF        OKDASR <> 'N'
     C                   MOVE      DDDASR        S1DASR
     C                   ENDIF

     C                   IF        OKDCSR <> 'N'
     C                   MOVE      DDDCSR        S1DCSR
     C                   ENDIF

     C                   IF        OKDASR <> 'N'
     C                   MOVE      DDDDSR        S1DDSR
     C                   ENDIF

     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALSECREF - Validation for Depot Security References       *
      *                                                               *
      *****************************************************************
     C     SRValSecRef   BEGSR
      *
      ** Depot 1
      ** =======
      *
     C                   IF        DDDASR <> *BLANKS AND
     C**********                   PSDC1 = *ZEROS                                             CSD027
     C                             PSDC1 = *BLANKS                                            CSD027
     C                   MOVE      'N'           OKDASR
     C                   ADD       1             IDx
     C                   MOVEL     'DDDASR'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0208'     MsgIdXAr(IDx)
     C                   ENDIF
      *
      ** Feature CSE011 is installed.
      *
     C                   IF        CSE011 = 'Y'

      *
      ** Check if code depot 1 already exists in securities file
     C                   IF        DDDASR <> *BLANKS

     C                   EVAL      WDASR = DDDASR
     C                   EVAL      WFound = 'N'
     C     WDASR         SETLL     SECTE
     C     WDASR         READE     SECTE                                  01

     C                   DOW       *IN01 = *OFF AND
     C                             WFound = 'N'
      *
      ** Check if security shortname is different
     C                   IF        S1SESN <> SESN
     C                   EVAL      WFound = 'Y'
     C                   ENDIF

     C     WDASR         READE     SECTE                                  01
     C                   ENDDO
      *
      ***Depot*1*code*already*exist*in*security*file,*send*error******                        210378
      ** Depot 1 code already exist in security file, send warning                            210378
     C                   IF        WFound = 'Y'
      *
      ** Security ref. 1 (DDDASR) already used for SESN
     C**********         MOVE      'N'           OKDASR                                       210378
     C**********         ADD       1             IDx                                          210378
     C**********         MOVEL     'DDDASR'      FldNamXAr(IDx)                               210378
     C**********         MOVEL     'SEA0255'     MsgIdXAr(IDx)                                210378
     C**********         EVAL      MsgDtaXAr(IDx) = DASR + SESN                               210378
     C                   MOVE      'W'           OKDASR                                       210378
     C                   ADD       1             WIx                                          210378
     C                   MOVEL     'DDDASR'      WFldNmXAr(WIx)                               210378
     C                   MOVEL     'SEA0255'     WMsgIdXAr(WIx)                               210378
     C**********         EVAL      WMsgDtXAr(WIx) = DASR + SESN                      210378 MD000091
     C                   EVAL      BLen = %Len(%Trim(DASR))                                 MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(DASR)                     MD000091
     C                   EVAL      BLen = %Len(%Trim(SESN))                                 MD000091
     C                   EVAL      WMsgDtXAr(WIx) = %TRIM(WMsgDtXAr(WIx))                   MD000091
     C                                             +%TRIM(SESN)                             MD000091
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF
      *
      ** Depot 2
      ** =======
      *
     C                   IF        DDDCSR <> *BLANKS AND
     C**********                   PSDC2 = *ZEROS                                             CSD027
     C                             PSDC2 = *BLANKS                                            CSD027
     C                   MOVE      'N'           OKDCSR
     C                   ADD       1             IDx
     C                   MOVEL     'DDDCSR'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0209'     MsgIdXAr(IDx)
     C                   ENDIF
      *
      ** Feature CSE011 is installed.
      *
     C                   IF        CSE011 = 'Y'
      *
      ** Check if code depot 2 already exists in securities file
     C                   IF        DDDCSR <> *BLANKS

     C                   EVAL      WDCSR = DDDCSR
     C                   EVAL      WFound = 'N'
     C     WDCSR         SETLL     SECT2
     C     WDCSR         READE     SECT2                                  01

     C                   DOW       *IN01 = *OFF AND
     C                             WFound = 'N'
      *
      ** Check if security shortname is different
     C                   IF        S1SESN <> SESN
     C                   EVAL      WFound = 'Y'
     C                   ENDIF

     C     WDCSR         READE     SECT2                                  01
     C                   ENDDO
      *
      ***Depot*2*code*already*exist*in*security*file,*send*error*******                       210378
      ** Depot 2 code already exist in security file, send warning                            210378
     C                   IF        WFound = 'Y'
      *
      ** Security ref. 2 (DDDCSR) already used for SESN
     C**********         MOVE      'N'           OKDCSR                                       210378
     C**********         ADD       1             IDx                                          210378
     C**********         MOVEL     'DDDCSR'      FldNamXAr(IDx)                               210378
     C**********         MOVEL     'SEA0256'     MsgIdXAr(IDx)                                210378
     C**********         EVAL      MsgDtaXAr(IDx) = DCSR + SESN                               210378
     C                   MOVE      'W'           OKDCSR                                       210378
     C                   ADD       1             WIx                                          210378
     C                   MOVEL     'DDCCSR'      WFldNmXAr(WIx)                               210378
     C                   MOVEL     'SEA0256'     WMsgIdXAr(WIx)                               210378
     C**********         EVAL      WMsgDtXAr(WIx) = DCSR + SESN                      210378 MD000091
     C                   EVAL      BLen = %Len(%Trim(DCSR))                                 MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(DCSR)                     MD000091
     C                   EVAL      BLen = %Len(%Trim(SESN))                                 MD000091
     C                   EVAL      WMsgDtXAr(WIx) = %TRIM(WMsgDtXAr(WIx))                   MD000091
     C                                             +%TRIM(SESN)                             MD000091
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF
      *
      ** Depot 3
      ** =======
      *
     C                   IF        DDDDSR <> *BLANKS AND
     C**********                   PSDC3 = *ZEROS                                             CSD027
     C                             PSDC3 = *BLANKS                                            CSD027
     C                   MOVE      'N'           OKDDSR
     C                   ADD       1             IDx
     C                   MOVEL     'DDDDSR'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0210'     MsgIdXAr(IDx)
     C                   ENDIF
      *
      ** Feature CSE011 is installed.
      *
     C                   IF        CSE011 = 'Y'
      *
      ** Check if code depot 3 already exists in securities file
     C                   IF        DDDDSR <> *BLANKS

     C                   MOVE      DDDDSR        WDDSR
     C                   EVAL      WFound = 'N'
     C     WDDSR         SETLL     SECT3
     C     WDDSR         READE     SECT3                                  01

     C                   DOW       *IN01 = *OFF AND
     C                             WFound = 'N'
      *
      ** Check if security shortname is different
     C                   IF        S1SESN <> SESN
     C                   EVAL      WFound = 'Y'
     C                   ENDIF

     C     WDDSR         READE     SECT3                                  01
     C                   ENDDO
      *
      ***Depot*3*code*already*exist*in*security*file,*send*error******                        210378
      ** Depot 3 code already exist in security file, send warning                            210378
     C                   IF        WFound = 'Y'
      *
      ** Security ref. 3 (DDDDSR) already used for SESN
     C**********         MOVE      'N'           OKDDSR                                       210378
     C**********         ADD       1             IDx                                          210378
     C**********         MOVEL     'DDDDSR'      FldNamXAr(IDx)                               210378
     C**********         MOVEL     'SEA0257'     MsgIdXAr(IDx)                                210378
     C**********         EVAL      MsgDtaXAr(IDx) = DDSR + SESN                               210378
     C                   MOVE      'W'           OKDDSR                                       210378
     C                   ADD       1             WIx                                          210378
     C                   MOVEL     'DDDDSR'      WFldNmXAr(WIx)                               210378
     C                   MOVEL     'SEA0257'     WMsgIdXAr(WIx)                               210378
     C**********         EVAL      WMsgDtXAr(WIx) = DDSR + SESN                      210378 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDSR))                                 MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(DDSR)                     MD000091
     C                   EVAL      BLen = %Len(%Trim(SESN))                                 MD000091
     C                   EVAL      WMsgDtXAr(WIx) = %TRIM(WMsgDtXAr(WIx))                   MD000091
     C                                             +%TRIM(SESN)                             MD000091
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF


     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Settlement depot customer 1, from PF/INVTPD
     C                   PARM                    PSDC1
      *
      ** Settlement depot customer 2, from PF/INVTPD
     C                   PARM                    PSDC2
      *
      ** Settlement depot customer 3, from PF/INVTPD
     C                   PARM                    PSDC3
      *
      ** SWITCHABLE FEATURE
      ** ==================
      *
      ** Duplicate security code check
     C                   PARM                    CSE011
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *                                                                                       210378
      ** Warning fields/message IDs/message data (arrays) from/to caller                      210378
     C                   PARM                    WFldNmXAr                                    210378
     C                   PARM                    WMsgIDxAr                                    210378
     C                   PARM                    WMsgDtXAr                                    210378
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
