     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Diary Events Call/Put Percentage')   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVDCPRI - Validate Diary Events Call/Put Percentage         *
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
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      *                 CAP140  *CREATE    Date 17Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
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
      *  SrValCPRI - Validate Call/Put Percentage                     *
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
      ** SE Diary Events retrieve from file - file format
     D CrDEFilFmt    E DS                  EXTNAME(SEDEVD)
     D                                     PREFIX(Cr)
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
     D WCALPC          S              7P 3
     D WTOTPC          S              7P 3
     D WSDTP           S              7P 3
     D PPROT           S              1A
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
     C                   EVAL      WCALPC = 0
     C                   EVAL      WSDTP = 0
      *
     C                   EXSR      SrValCPRI
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKCPRI = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ELSE
     C                   Z-ADD     WCALPC        S2SDPC
     C                   ENDIF
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValCPRI - Validate Call/Put Percentage                     *
      *                                                               *
      *****************************************************************
 
     C     SrValCPRI     BEGSR
      *
      ** If event type is 'PP' and investment processing type is non-shares,
      ** call percentage is mandatory
      *
     C                   IF        DDSDET = 'PP' AND PPROT <> '4'
     C                             AND DDCPRI = *BLANKS
     C                   MOVE      'N'           OKCPRI
     C                   ADD       1             IDx
     C                   MOVEL     'DDCPRI'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0361'     MsgIdXAr(IDx)
     C                   GOTO      EValCPRI
     C                   ENDIF
      *
      ** Check for valid number.
      *
     C                   IF        DDCPRI <> *BLANKS
      *
      ** Check for valid number
     C                   EVAL      ZFIELD = *BLANKS
     C                   EVAL      ZFIELD = DDCPRI
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM      3             ZADEC
     C                   PARM      3             ZADIG
 
     C                   IF        ZALIGNok = 'N'
     C                   MOVE      'N'           OKCPRI
     C                   ADD       1             IDx
     C                   MOVEL     'DDCPRI'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0362'     MsgIdXAr(IDx)
     C                   GOTO      EValCPRI
     C                   ENDIF
      *
     C                   MOVE      ZFIELD        WCALPC
      *
     C                   IF        DDSDET <> 'PP'
      *
      ** Entry not valid if Call/Put Amount is entered.
     C                   IF        DDCLAT <> *BLANKS
     C                   MOVE      'N'           OKCPRI
     C                   ADD       1             IDx
     C                   MOVEL     'DDCPRI'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0348'     MsgIdXAr(IDx)
     C                   GOTO      EValCPRI
     C                   ENDIF
      *
      ** Must not exceed 100 percent.
     C                   IF        WCALPC > 100
     C                   MOVE      'N'           OKCPRI
     C                   ADD       1             IDx
     C                   MOVEL     'DDCPRI'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0368'     MsgIdXAr(IDx)
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Fetch total Percentage for this security
      *
     C     DDSDSN        SETGT     SEDEVDF
     C                   READP     SEDEVDF                                01
      *
     C                   DOW       NOT *IN01
      *
      ** Check record is not a cancelled record
     C                   IF        RECI <> 'C'
      *
      ** Check same Security
     C                   IF        DDSDSN = SDSN
      *
      ** Check same Event type
     C                   IF        SDET = 'PP'
     C                   Z-ADD     SDTP          WSDTP
     C                   LEAVE
     C                   ENDIF
      *
      ** Exit loop if security are not the same.
     C                   ELSE
     C                   MOVE      *ON           *IN01
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READP     SEDEVDF                                01
     C                   ENDDO
      *
     C                   IF        *IN01
     C                   MOVE      D1CPDP        WSDTP
     C                   ENDIF
      *
      ** Check total will not exceed 100%
     C                   EVAL      WTOTPC = WSDTP + WCALPC
      *
      ** If amendment, subtract the original percentage that was entered.
     C                   IF        DDACTN = 'A'
     C                   EVAL      WTOTPC = WTOTPC - CrSDPC
     C                   ENDIF
      *
     C                   IF        WTOTPC > 100
     C                   MOVE      'N'           OKCPRI
     C                   ADD       1             IDx
     C                   MOVEL     'DDCPRI'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0363'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     EValCPRI      ENDSR
 
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
      ** SE Diary Events retrieve from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
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
