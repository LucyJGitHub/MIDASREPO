     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade display - third screen')                *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRADTDSP - Trade display - third screen                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CSF011A            Date 28Nov11               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE065 - Cost Yield Amort. on Mortgage Backed Assets         *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** SE Trade details display (third screen)
     FSETRADTDF CF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      * FUNCTION OF INDICATORS                                        *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *                                                               *
      *       62  Processing type <> 1,3,5,6,8 & Trade basis <> P,Y   *
      *       66  Disable input fields that are non amendable         *
      *       70  Protect deal detail fields                          *
      *                                                               *
      *       80  Not multibranching                                  *
      *       81  Bulk input option not used                          *
      *                                                               *
      *       96  Subfile control                                     *
      *       97  Subfile end                                         *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
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
 
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
 
     D @EIX            DS
     D  @EI                    1     60
     D                                     DIM(60)
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Securities Trading ICD
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D TrPrim        E DS                  EXTNAME(SETRPRPD)
     D TrThir        E DS                  EXTNAME(SETRTHPD)
     D OKTrThir      E DS                  EXTNAME(SEETRTHPD)
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D SEC_RECI      E                     EXTFLD(RECI)
     D SEC_ZZ005     E                     EXTFLD(ZZ005)
     D SEC_LCD       E                     EXTFLD(LCD)
     D SEC_CHTP      E                     EXTFLD(CHTP)
     D SEC_TNLU      E                     EXTFLD(TNLU)
 
      ** Investment Type Details
     D INVTP         E DS                  EXTNAME(INVTPD)
     D INV_RECI      E                     EXTFLD(RECI)
     D INV_LCD       E                     EXTFLD(LCD)
     D INV_CHTP      E                     EXTFLD(CHTP)
     D INV_TNLU      E                     EXTFLD(TNLU)
     D INV_NDEC      E                     EXTFLD(NDEC)                                       CAS006
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D DDSTAT          S              9
     D DDSRNME         S             41
     D PBYSL           S              1
     D PINKC           S              1
     D PINKE           S              1
     D PINKL           S              1
     D PWriteOnly      S              1
     D PCurTINC        S              1
     D C               S              2  0
     D E               S              2  0
     D PRTCD           S              7
     D POPTN           S              7
     D WrkNTCR         S             11  7
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Main processing
 
     C                   EXSR      MAIN
 
      ** Return
 
     C                   IF        PINKC = '1'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN - Main processing                                       *
      *                                                               *
      *****************************************************************
 
     C     MAIN          BEGSR
 
      ** Move 'OK' flags into array (for checking)
 
     C                   EVAL      @EIX = OKTrThir
 
      ** Set screen error indicators according to status of OK flags
 
     C                   Z-ADD     1             C
     C                   Z-ADD     10            E
 
     C                   DOU       C > 60
     C                   IF        @EI(C) = 'N'  OR  @EI(C) = 'W'
     C                   EVAL      *IN(E) = *ON
     C                   ENDIF
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
 
      ** Set up the transaction reference to be used by the message handler
 
     C                   EVAL      TranRef = DDTDRF
     C                   EVAL      ActionCode = DDACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      ** If Processing type <> 1,3,5,6,8 & Trade basis <> P or Y,
      ** Non-display Accrued Int fields
 
     C                   EVAL      *IN62 = *OFF
     C                   IF        (PROT <> '1'  AND  PROT <> '3'  AND
     C                              PROT <> '5'  AND  PROT <> '6'  AND
     C                              PROT <> '8'  AND  PROT <> '9')  OR
     C                             STBS = 'D'
     C                   EVAL      *IN62 = *ON
     C                   ENDIF
 
      ** Protect fields depending on action code
 
     C                   EVAL      *IN70 = *OFF
     C                   IF        DDACTN <> 'I'  AND  DDACTN <> 'C'  AND
     C                             DDACTN <> 'A'
     C                   EVAL      *IN70 = *ON
     C                   ENDIF
 
      ** Disable input fields that are non amendable, if trade is complete
 
     C                   EVAL      *IN66 = *OFF
     C                   IF        DDACTN = 'A' AND PCurTINC <> 'I'
     C                   EVAL      *IN66 = *ON
     C                   ENDIF
 
      ** Write message subfile, details and footer screens
 
     C                   TIME                    DDTIME
     C                   WRITE     SETRADTS0
     C                   WRITE     SETRADTD1
     C                   WRITE     SETRADTF1
 
      ** If not write only, read details screen
 
     C                   IF        PWriteOnly <> 'Y'
     C                   READ      SETRADTD1                              99
     C                   ENDIF
 
      ** Set screen error indicators off
 
     C                   MOVEA     @Z0           *IN(10)
 
      ** Set return keys
 
     C                   MOVE      *INKC         PINKC
     C                   MOVE      *INKE         PINKE
     C                   MOVE      *INKL         PINKL
      *
     C                   ENDSR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial processing                                  *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
      ** Return code
 
     C                   PARM                    RetCodeIn
 
      ** Trade in screen format
 
     C                   PARM                    TrPrim
     C                   PARM                    TrThir
 
      ** Trade status
      ** Security report name
      ** Coupon Rate using Net Treasury Rate
      ** Net Treasury Price
 
     C                   PARM                    DDSTAT
     C                   PARM                    DDSRNME
     C                   PARM                    DDHACR
     C                   PARM                    DDPRICN
 
      ** Trade incomplete ind
 
     C                   PARM                    PCurTINC
 
      ** Security Details
      ** Investment Type Details
 
     C                   PARM                    SECTY
     C                   PARM                    INVTP
 
      ** Buy-sell back
 
     C                   PARM                    PBYSL
 
      ** Fields in error
 
     C                   PARM                    OKTrThir
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** OUTPUTS
      ** Function keys
 
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKL
 
      ** Write screen with no read indicator
 
     C                   PARM                    PWriteOnly
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'SETRADTDSP'
 
      ** Move user and workstation ID to screen fields
 
     C                   EVAL      DDUSER = PsUser
     C                   EVAL      DDWID = PsJobName
 
      ** Access bank details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBASE = 901
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Securities Trading details
 
     C                   CALLB     'AOSTRDR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDSTRDPD'
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBASE = 902
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Message subfile control
 
     C                   EVAL      *IN97 = *ON
     C                   MOVEL     '*'           DDPGMQ
 
      ** Single-branching (protect booking branch)
 
     C                   IF        BJSBRC <> *BLANK
     C                   EVAL      *IN80 = *ON
     C                   ENDIF
 
      ** Bulk Input Option not used
 
     C                   IF        BVBIOP <> 'Y'
     C                   EVAL      *IN81 = *ON
     C                   ENDIF
 
      ** If Buy-sell back processing, write appropriate screen header
 
     C                   IF        PBYSL = 'Y'
     C                   EVAL      *IN86 = *ON
     C                   ELSE
     C                   EVAL      *IN86 = *OFF
     C                   ENDIF
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SE *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SECPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
** @Z0
000000000000000000000000000000000000000000000000000000000000
