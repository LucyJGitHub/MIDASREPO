     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Diary Events Current Factor')        *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVDSDCP - Validate Diary Events Current Factor              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. DUG502             Date 29Nov17               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSE072             Date 05Apr05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      *                 CAP140  *CREATE    Date 17Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DUG502 - Security Diary enhancements (Recompile)             *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSE072 - INT-CC3 - Brazilian C-Bonds                         *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Use for chaining to file                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrCurFac - Validate Current Factor                           *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Security Diary Events
     FSEDEV     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(IF)
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
      ** SE Diary Events for file update - file format
     D NwDEFilFmt    E DS                  EXTNAME(SEVSEDEPD)
      *
      ** SE Diary Events screen error indicators
     D SEESEDE       E DS                  EXTNAME(SEESEDEPD)
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     D NwDE1ScnFmt   E DS                  EXTNAME(SESEDEPD)
      *
      ** Externally described DS for security details
     D PSectyd       E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(D1)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Work parameters
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZALIGNok        S              1A
     D WCurFactor      S             10P 9
     D PEvtDno         S              5P 0
     D CSE072          S              1A                                                      CSE072
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
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Initialise work variables.
     C                   EVAL      IDx = 0
     C                   EVAL      WCurFactor = 0
      *
     C                   EXSR      SrCurFac
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKSDCP = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ELSE
     C                   Z-ADD     WCurFactor    S2SDCP
     C                   ENDIF
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCurFac - Validate Current Factor                           *
      *                                                               *
      *****************************************************************
 
     C     SrCurFac      BEGSR
      *
      ** Current factor - must not be blank if Repayment amount also
      * blank.
     C                   IF        DDSDCP = *BLANKS
     C                   IF        DDSRPT = *BLANKS
     C                   MOVE      'N'           OKSDCP
     C                   ADD       1             IDx
     C                   MOVEL     'DDSDCP'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0369'     MsgIdXAr(IDx)
     C                   ENDIF
      *
      ** Current factor entered, error if Repayment amount also entered
     C                   ELSE
     C                   IF        DDSRPT <> *BLANKS
     C                   MOVE      'N'           OKSDCP
     C                   ADD       1             IDx
     C                   MOVEL     'DDSDCP'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0370'     MsgIdXAr(IDx)
     C                   ENDIF
      *
      ** Check for valid number
     C                   EVAL      ZFIELD = *BLANKS
     C                   EVAL      ZFIELD = DDSDCP
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM      9             ZADEC
     C                   PARM      1             ZADIG
 
     C                   IF        ZALIGNok = 'N'
     C                   MOVE      'N'           OKSDCP
     C                   ADD       1             IDx
     C                   MOVEL     'DDSDCP'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0371'     MsgIdXAr(IDx)
     C                   ELSE
      *
      ** Check value not greater than 1
     C                   MOVE      ZFIELD        WCurFactor
     C                   IF        CSE072   = 'N'                                             CSE072
     C                   IF        WCurFactor > 1
     C                   MOVE      'N'           OKSDCP
     C                   ADD       1             IDx
     C                   MOVEL     'DDSDCP'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0371'     MsgIdXAr(IDx)
     C                   ENDIF
     C                   ENDIF                                                                CSE072
     C                   ENDIF
      *
      **  Check not greater than secty current factor
      *
     C                   IF        CSE072   = 'N'                                             CSE072
     C                   IF        DDSDCP <> *BLANKS AND
     C                             WCurFactor > D1CFCT
     C                   MOVE      'N'           OKSDCP
     C                   ADD       1             IDx
     C                   MOVEL     'DDSDCP'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0372'     MsgIdXAr(IDx)
     C                   ENDIF
     C                   ENDIF                                                                CSE072
      *
      ** The previous 'MP' record cannot have a Repayment method indicator
      ** of 'Y'
      *
     C     KDEVKA        SETLL     SEDEVDF
     C                   READP     SEDEVDF                                01
      *
     C                   DOW       NOT *IN01
      *
      ** Check record is not a cancelled record
     C                   IF        IFRECI <> 'C'
      *
      ** Check same Security
     C                   IF        IFSDSN = DDSDSN
      *
      ** Check same Event type
     C                   IF        IFSDET = 'MP'
     C                   IF        IFSRMI = 'Y'
     C                   MOVE      'N'           OKSDCP
     C                   ADD       1             IDx
     C                   MOVEL     'DDSDCP'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0373'     MsgIdXAr(IDx)
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
      *
      ** Exit loop if security are not the same.
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READP     SEDEVDF                                01
     C                   ENDDO
      *
      ** The next 'MP' record cannot have a Repayment method indicator
      ** of 'Y'
      *
     C     KDEVKA        SETLL     SEDEVDF
     C                   READ      SEDEVDF                                01
      *
     C                   DOW       NOT *IN01
      *
      ** Check record is not a cancelled record
     C                   IF        IFRECI <> 'C'
      *
      ** Check same Security
     C                   IF        IFSDSN = DDSDSN
      *
      ** Check same Event type
     C                   IF        IFSDET = 'MP'
     C                   IF        IFSRMI = 'Y'
     C                   MOVE      'N'           OKSDCP
     C                   ADD       1             IDx
     C                   MOVEL     'DDSDCP'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0373'     MsgIdXAr(IDx)
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
      *
      ** Exit loop if security are not the same.
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      SEDEVDF                                01
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
 
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
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** Event date (Day number)
     C                   PARM                    PEvtDno
      *                                                                                       CSE072
      ** SWITCHABLE FEATURE                                                                   CSE072
      ** ==================                                                                   CSE072
      *                                                                                       CSE072
      ** SE Transaction Enhancement                                                           CSE072
     C                   PARM                    CSE072                                       CSE072
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
      *
     C     KDEVKA        KLIST
     C                   KFLD                    DDSDSN
     C                   KFLD                    PEvtDno
     C                   KFLD                    DDSDET
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
