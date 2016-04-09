     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate rate fix days (FRA)')
      *****************************************************************
      *                                                               *
      *  Midas- FRA/IRS Moudle                                        *
      *                                                               *
      *  IRVRATEFIX - Validate Rate Fix                               *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Rate Fix Days and confirms if it is valid. If it  *
      *             is valid the 10A return code will be blank; if it *
      *             is not it will contain 'Error'                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CIR011             Date 15Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 166636             Date 27Aug99               *
      *                 163378             Date 02Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 24Aug98               *
      *                 CAP003  *CREATE    Date 01Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CIR011 - FRA/IRS Rate Fix Days Adjustment                    *
      *  CIR005 - FRA/IRS Business Day Conventions                    *
      *  166636 - FRA rate fix date not set if value date a holiday   *
      *  163378 - Our/ Their  Fix/Floating  Rate Days  is defaulting  *
      *           to '02'   but not showing on the screen at the time *
      *           of insertion. Move the default value to the screen  *
      *           field                                               *
      *  CAP004 - Return edited version of field to validation        *
      *           control module                                      *
      *                                                               *
      *  CAP003 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
      **Rate Fix Days passed as parameter from calling program
     D   SUFRFD        S              2A
 
      **ZALIGN indicator passed back from ZALIGN as parameter
     D   ZALIGNok      S              1A
 
      **Value date indicator passed as a parameter to module
     D   VDATXok       S              1A
 
      **Currency field passed as a parameter from calling programme
     DSUCUCYok         S              1A
 
      **Indicator passed as paramater to calling programmer
     D   SUFRFDok      S              1A
 
      **Holiday Indicator passed from ZCHK to programme.
     D   ZIND          S              1A
 
      **Rate fix days used by DLBACK
     D    ZRFDY        S              5  0
 
      **Valid Value date passed as a parameter
     D   VDATX         S              5  0
 
      **'Currency for rate fix holiday' flag from FRA/IRS I.C.D. passed as parameter
     D   BQCRFH        S              1A
 
      **Currency field for DLBACK
     D   ZCCY          S              3A
 
      **Location Code for DLBACK
     D   ZLOC          S              3A
 
      **Valid value date for DLBACK
     D   ZINDT         S              5  0
 
      **Rate Fix Date field for DLBACK
     D   ZRFDT         S              5  0
 
      **Work Field for DLBACK
     D   ZWKFLD        S              5  0
 
      **System Location code passed as a parameter
     D   BJSLCD        S              3A
 
      **Day number passed to ZCHKH as a parameter
     D   ZDAYNO        S              5  0
 
      **Rate fix days passed as a parameter
     D   ZFIELD        S             16A
                                                                                CIR005
      ** Currencies for Rate Fixing Convention                                  CIR005
     D RRatCur         S             30A                                        CIR005
                                                                                              CIR011
     D CIR011          S              1A                                                      CIR011
     D PAJCD           S              3A                                                      CIR011
     D PNDADJ          S              1  0                                                    CIR011
     D PFRFDX          S              2  0                                                    CIR011
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **Message Field passed back as parameter to calling programme
     DMsgid1           S                   LIKE(#Msgid)
 
      **Message Field passed back as parameter to calling programme
     DWMsgid1          S                   LIKE(#Msgid)
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      **Length of Decimal field passed to ZALIGN as parameter
     DZADEC            S              1  0
 
      **Length of digital field passed as a parameter to ZALIGN
     DZADIG            S              2  0
 
      **Runday number passed as a parameter
     DBJRDNB           S              5  0
 
      **Currency field passed as a parameter from calling programme
     DSUCUCY           S              3A
 
      **Rate Fix Days Default Value field
     DUINFDX           S              5  0
 
      **Currency code passed to programme as parameter
     DBLCYCD           S              3A
 
      **Local currency code passed to programme as parameter
     DBJLCCY           S              3A
 
      ** +--------------------------------------+                               CIR005
      ** ¦ Arrays and Data Structures           ¦                               CIR005
      ** ¦ ==========================           ¦                               CIR005
      ** +--------------------------------------+                               CIR005
      *                                                                         CIR005
     D RRatCurOk       S              1    DIM(10)                              CIR005
      *                                                                         CIR005
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CIR005
      ** EXTERNAL DS FOR SAR DETAILS                                            CIR005
      *                                                                         CIR005
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CIR005
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                     CIR005
      *                                                                         CIR005
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  CIR011
      ** EXTERNAL DS FOR CURRENCY DETAILS                                                     CIR011
      *                                                                                       CIR011
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CIR011
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                                   CIR011
      *
      ** +--------------------------------------+
      ** ¦                                      ¦
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
     C                   RESET                   WMsgid1
     C                   MOVE      'Y'           SUFRFDok
      *
      ** Validate Rate Fix Days using ZALIGN.
      *
     C                   Z-ADD     0             UFRFDX            2 0
     C     SUFRFD        IFNE      *BLANKS
      *
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     02            ZADIG
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SUFRFD        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        UFRFDX
     C                   ELSE
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMA0027'     Msgid1
     C                   MOVE      'N'           SUFRFDok
     C                   END
      *
     C                   ELSE
      * Set up Rate Fix Days Default value
     C     SUCUCY        IFNE      BJLCCY
     C     SUCUCY        ORNE      BLCYCD
     C                   Z-ADD     02            UFRFDX
      *                                                                         163378
      * Move defaulted value to the screen field as well .                      163378
     C                   MOVE      UFRFDX        SUFRFD                         163378
      *
     C                   END
      *
     C                   END
     C/COPY WNCPYSRC,DL1601IC19
     C                   IF        (CIR011 = 'Y')                                             CIR011
      *                                                                                       CIR011
      ** Rate Fix Days must be greater than adjustment days in PF/FRRFXD                      CIR011
      ** Validate only if no error in value date/floating rate fix days & ccy                 CIR011
      *                                                                                       CIR011
     C     VDATXok       IFNE      'N'                                                        CIR011
     C     SUFRFDok      ANDNE     'N'                                                        CIR011
     C     SUCUCYok      ANDNE     'N'                                                        CIR011
      *                                                                                       CIR011
     C                   CALLB     'AOCURRR0'                                                 CIR011
     C                   PARM      *BLANKS       @RTCD                                        CIR011
     C                   PARM      '*KEY   '     @OPTN                                        CIR011
     C                   PARM      SUCUCY        PAJCD                                        CIR011
     C     SDCURR        PARM      SDCURR        DSSDY                                        CIR011
      *                                                                                       CIR011
     C                   MOVE      A6FXDY        PNDADJ                                       CIR011
     C     UFRFDX        SUB       PNDADJ        PFRFDX                                       CIR011
      *                                                                                       CIR011
      ** If less, it is an error                                                              CIR011
      *                                                                                       CIR011
     C     PFRFDX        IFLT      0                                                          CIR011
      *                                                                                       CIR011
     C                   MOVE      'Y'           Errorfound                                   CIR011
     C                   MOVEL     'MMA0027'     Msgid1                                       CIR011
     C                   MOVE      'N'           SUFRFdOk                                     CIR011
      *                                                                                       CIR011
     C                   ENDIF                                                                CIR011
      *                                                                                       CIR011
     C                   ENDIF                                                                CIR011
      *                                                                                       CIR011
     C                   ENDIF                                                                CIR011
      *
      ** Cross check  VALUE DATE / RATE FIX DAYS.
      *
     C                   Z-ADD     0             UINFDX
     C*****VDATXok       IFEQ      'Y'                                          166636
     C*****SUFRFDok      ANDEQ     'Y'                                          166636
     C*****SUCUCYok      ANDEQ     'Y'                                          166636
     C     VDATXok       IFNE      'N'                                          166636
     C     SUFRFDok      ANDNE     'N'                                          166636
     C     SUCUCYok      ANDNE     'N'                                          166636
     C                   Z-ADD     VDATX         ZINDT
     C                   Z-ADD     UFRFDX        ZRFDY
      *
      ** If 'currency for rate fix holiday' flag from FRA/IRS I.C.D.
      ** is 'F', 'L' or 'D', set currency code to 'sterling code',
      ** 'local currency code' or 'screen currency code' respectively
      *
     C     BQCRFH        IFEQ      'F'
     C                   MOVE      BLCYCD        ZCCY
     C                   END
      *
     C     BQCRFH        IFEQ      'L'
     C                   MOVE      BJLCCY        ZCCY
     C                   END
      *
     C     BQCRFH        IFEQ      'D'
     C     BQCRFH        OREQ      ' '
     C                   MOVE      SUCUCY        ZCCY
     C                   END
     C*
     C                   MOVE      *BLANKS       ZLOC
      *                                                                         CIR005
      ** If Business Day Convention Enhancement is on.  Check Currency for Rate CIR005
      ** Convention Flags are equal to 'Y'                                      CIR005
      *                                                                         CIR005
     C                   IF        (CIR005 = 'Y')                               CIR005
     C                   Z-ADD     1             Ctr               2 0          CIR005
     C                   Z-ADD     0             NumOkFl           2 0          CIR005
     C                   DOW       (Ctr <= 10)                                  CIR005
     C                   IF        (RRatCurOk(Ctr) <> 'N')                      CIR005
     C                   EVAL      NumOkFl = NumOkFl + 1                        CIR005
     C                   ENDIF                                                  CIR005
     C                   EVAL      Ctr = Ctr + 1                                CIR005
     C                   ENDDO                                                  CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
      ** If Business Day Convention Enhancement is on and first Ccy for Rate    CIR005
      ** Convention is not equal to blanks. Use new module IRRTFXCNV to         CIR005
      ** calculate for rate fix days.                                           CIR005
      *                                                                         CIR005
     C                   Z-ADD     ZINDT         ZRFDT                          CIR005
     C                   IF        ((CIR005 = 'Y') And (%SUBST(RRatCur:1:3)     CIR005
     C                             = *Blank)) Or (CIR005 = 'N')                 CIR005
     C                   EXSR      DLBACK
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C                   IF        ((CIR005 = 'Y') And (%SUBST(RRatCur:1:3)     CIR005
     C                             <> *Blank) And (NumOkFl = 10))               CIR005
     C                   EVAL      ZRFDT = *ZERO                                CIR005
     C                   CALLB     'IRRTFXCNV'                                  CIR005
     C                   PARM                    ZINDT                          CIR005
     C                   PARM                    UFRFDX                         CIR005
     C                   PARM                    ZLOC                           CIR005
     C                   PARM                    RRatCur                        CIR005
     C                   PARM                    ZRFDT                          CIR005
     C                   ENDIF                                                  CIR005
      *
     C     ZRFDT         IFLT      BJRDNB
     C                   MOVE      'N'           SUFRFDok
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'MMA0015'     Msgid1
     C                   ELSE
     C                   Z-ADD     ZRFDT         UINFDX
     C                   END
     C                   END
      * result must be a working day
      * in the local currency.
      *                                                                         CIR005
      ** Do not process MMA0016 if Business Day Enhancement is on and           CIR005
      ** first Ccy for Rate Fixing Convention is not equal to blanks.           CIR005
      *                                                                         CIR005
     C                   IF        ((CIR005 = 'Y') And (%SUBST(RRatCur:1:3)     CIR005
     C                             = *Blank)) Or (CIR005 = 'N')                 CIR005
     C     UINFDX        IFNE      0
     C                   Z-ADD     UINFDX        ZDAYNO
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      BJSLCD        ZLOC
 
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    ZIND
 
     C     ZIND          IFEQ      'H'
     C                   MOVE      'N'           SUFRFDok
     C                   MOVE      'N'           VDATXok
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'MMA0016'     Msgid1
     C                   END
     C                   END
     C                   ENDIF                                                  CIR005
 
     C*******************IF        ErrorFound = 'Y'                             166636
     C*******************EVAL      RetCodeIn = 'Error'                          166636
     C*******************ENDIF                                                  166636
 
      ** The return code is set in the following /COPY:                         166636
     C/COPY ZACPYSRC,SETRETCDE                                                  166636
 
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    ReturnCode                     166636
     C*******************PARM                    RetCodeIn                      166636
     C                   PARM                    Msgid1
     C                   PARM                    WMsgid1
     C                   PARM                    SUFRFD
     C                   PARM                    SUCUCY
     C                   PARM                    BJLCCY
     C                   PARM                    BLCYCD
     C                   PARM                    VDATXok
     C                   PARM                    SUFRFDok
     C                   PARM                    SUCUCYok
     C                   PARM                    VDATX
     C                   PARM                    BQCRFH
     C                   PARM                    BJSLCD
     C                   PARM                    BJRDNB
     C                   PARM                    UINFDX
     C                   PARM                    UFRFDX                         CAP004
     C                   PARM                    RRatCur                        CIR005
     C                   PARM                    RRatCurOk                      CIR005
      *                                                                         CIR005
      **  Access SAR details file to determine if Bus. Day Convention is on.    CIR005
      *                                                                         CIR005
     C                   CALL      'AOSARDR0'                                   CIR005
     C                   PARM      *BLANKS       @RTCD                          CIR005
     C                   PARM      '*VERIFY'     @OPTN                          CIR005
     C                   PARM      'CIR005'      @SARD                          CIR005
     C     SCSARD        PARM      SCSARD        DSFDY                          CIR005
      *                                                                         CIR005
     C     @RTCD         IFNE      *BLANKS                                      CIR005
     C     @RTCD         ANDNE     '*NRF   '                                    CIR005
     C     *LOCK         IN        LDA                                          CIR005
     C                   MOVEL     'SCSARDPD'    DBFILE                         CIR005
     C                   Z-ADD     901           DBASE                          CIR005
     C                   MOVEL     'CIR005'      DBKEY                          CIR005
     C                   OUT       LDA                                          CIR005
     C                   EXSR      *PSSR                                        CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C     @RTCD         IFEQ      *BLANKS                                      CIR005
     C                   MOVEL     'Y'           CIR005            1            CIR005
     C                   ELSE                                                   CIR005
     C                   MOVEL     'N'           CIR005                         CIR005
     C                   ENDIF                                                  CIR005
      *                                                                                       CIR011
      **  Access SAR details file to determine if Rate Fix Day Adj is on.                     CIR011
      *                                                                                       CIR011
     C                   CALL      'AOSARDR0'                                                 CIR011
     C                   PARM      *BLANKS       @RTCD                                        CIR011
     C                   PARM      '*VERIFY'     @OPTN                                        CIR011
     C                   PARM      'CIR011'      @SARD                                        CIR011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR011
      *                                                                                       CIR011
     C     @RTCD         IFNE      *BLANKS                                                    CIR011
     C     @RTCD         ANDNE     '*NRF   '                                                  CIR011
     C     *LOCK         IN        LDA                                                        CIR011
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CIR011
     C                   Z-ADD     902           DBASE                                        CIR011
     C                   MOVEL     'CIR011'      DBKEY                                        CIR011
     C                   OUT       LDA                                                        CIR011
     C                   EXSR      *PSSR                                                      CIR011
     C                   ENDIF                                                                CIR011
      *                                                                                       CIR011
     C     @RTCD         IFEQ      *BLANKS                                                    CIR011
     C                   MOVEL     'Y'           CIR011                                       CIR011
     C                   ELSE                                                                 CIR011
     C                   MOVEL     'N'           CIR011                                       CIR011
     C                   ENDIF
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
 
     C*****************************************************************
     C*   SR: DLBACK - TO CALCULATE RATE FIX DATE FOR FRA/IRS         *
     C*                                                               *
     C*****************************************************************
     C     DLBACK        BEGSR
     C*
     C**  Initialise Work Field
     C                   Z-ADD     ZINDT         ZINDT             5 0
     C                   Z-ADD     ZRFDY         ZRFDY             5 0
     C                   MOVE      ZCCY          ZCCY              3
     C                   Z-ADD     0             ZWKFLD            5 0
     C*
     C**  Set Rate Fix Date equal to Input Date
     C                   Z-ADD     ZINDT         ZRFDT             5 0
     C*
     C**  Perform the following processing until the work field is
     C**  greater than or equal to the Rate Fix Days
     C     ZWKFLD        DOUGE     ZRFDY
     C*
     C**  If the Rate Fix Days are not equal to zero subtract 1
     C**  from the Rate Fix Date
     C     ZRFDY         IFNE      0
     C                   SUB       1             ZRFDT
     C                   END
      *
      **  The following is repeated until the resultant date is
      **      proved to be a working day in the relevant currency
      **      and the relevent location.
      **  ZCHKH checks the Rate Fix Date for a holiday.
     C     ZIND          DOUEQ     'W'
     C                   Z-ADD     ZRFDT         ZDAYNO
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    SUCUCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND
      *
      **  If the date is a holiday, subtract 1 from the Rate Fix Date
     C     ZIND          IFEQ      'H'
     C                   SUB       1             ZRFDT
     C                   END
     C                   END
     C*
     C**  When a working day has been found, add 1 to the Work Field
     C                   ADD       1             ZWKFLD
     C                   END
     C*
     C                   ENDSR
     C********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
