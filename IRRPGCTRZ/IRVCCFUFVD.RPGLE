     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate premium value date (caps/cllrs)')
      *****************************************************************
      *                                                               *
      *  Midas - IRS Up-Front Value Date (Premium)                    *
      *                                                               *
      *  IRVCCFUFVD                                                   *
      *                                                               *
      *  Function:  This module validates the up-front fee amount     *
      *             in caps, collars and floors.                      *
      *             It returns a blank field if no error is found,    *
      *             otherwise it returns  'Error'.                    *
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. 167511             Date 14Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003   *CREATE   Date 18Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  167511 - FRA/IRS functions fail if dates contain invalid data*
      *           (also fix mistreatment of warning errors)           *
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
 
      ** External data structure for currency details.
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      **Second DS for access programs, long data structure.
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * switchable feature field passed as parameter.
     D CIR001          S              1A
 
      * upfront value date.
     D SUPVD           S              6A
 
      * upfront fee value.
     D SUPFE           S             14A
 
      * maturity date.
     D ZDATE           S              6A
 
      * work field for midas day number.
     D UPVDX           S              5P 0
 
      * day number for holiday passed as parameter.
     D ZDAYNO          S              5P 0
 
      * Deal date as midas deal number for file output.
     D DDATX           S              5P 0
 
      * Valid maturity date passed as a parameter.
     D MDATX           S              5P 0
 
      * Valid value date passed as parameter.
     D VDATX           S              5P 0
 
      * Currency entered checked against currency code.
     D SUCUCY          S              3A
 
      * Buy and sell indicator
     D SBYSL           S              1A
 
      * Payment settlement method passed as parameter.
     D SPSETM          S              2A
 
      * Currency field
     D ZCCY            S              3A
 
      * System location code passed as parameter.
     D BJSLCD          S              3A
 
      * contains relevant branch location
     D ZLOC            S              3A
 
      * receipt settlement method passed as a parameter from calling program.
     D SRSETM          S              2A
 
      **Rate Change Date passed to module by calling program
     D  STNICD         S              6A
 
      ** Date format indicator passed as a parameter to ZDATE
     D   BJDFIN        S              1A
 
      **Local currency code passed to program as parameter
     D   BJLCCY        S              3A
 
      **Holiday Check indicator passed from ZCHKH
     D   ZIND          S              1A
 
      ** Error flag passed back from ZDATE to module
     D  ErrorFlag      S              1A
 
      **Decimal data length passed as a parameter to ZALIGN
     D   ZADEC         S              1  0
 
      **Digital data length passed as a parameter to ZALIGN
     D   ZADIG         S              2  0
 
      **Field Passed to ZALIGN on which the work is done
     D   ZFIELD        S             16A
 
      **Indicator to show whether or not ZALIGN was successful
     D   ZALIGNok      S              1A
 
      ** Error message passed back to calling program from module
     D  Msgid1         S                   LIKE(#Msgid)
 
      ** Error message passed back to calling program from module
     D  WMsgid1        S                   LIKE(#Msgid)
 
      ** Error message passed back to calling program from module
     D  WMsgid2        S                   LIKE(#Msgid)
 
      * fee amount indicator
     D SUPFEok         S              1A
 
      * deal date indicator
     D DDATXok         S              1A
 
      * value date indicator
     D VDATXok         S              1A
 
      * maturity date indicator
     D MDATXok         S              1A
 
      * Deal CCY code valid indicator
     D SUCUCYok        S              1A
 
      ** +--------------------------------------+
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
 
 
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   WarnFound                      167511
     C                   RESET                   Msgid1
     C                   RESET                   WMsgid1
     C                   RESET                   WMsgid2
      **
      *****************************************************************
      *                                                               *
      *                 IRS UP-FRONT FEE (PREMIUM)                    *
      *                                                               *
      *****************************************************************
      *
      ** Only perform Up-front Fee validation if enhancement
      ** CIR001 is ON.
      *
     C     CIR001        IFEQ      'Y'
      *
     C                   MOVE      'N'           ErrorFound
     C                   MOVE      'Y'           SUPFEok
 
      ** If Deal date and Maturity date are valid
 
     C*****DDATXok       IFEQ      'Y'                                          167511
     C*****MDATXok       ANDEQ     'Y'                                          167511
     C     DDATXok       IFNE      'N'                                          167511
     C     MDATXok       ANDNE     'N'                                          167511
 
      ** Validate Up-front Value Date.
 
     C     SUPVD         IFEQ      *BLANKS
     C     SUPFE         IFNE      *BLANKS
 
 
      * Avoid exceeding size of error code array.
 
     C                   MOVE      'MMA066'      Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   END
 
      *
     C                   MOVE      *BLANKS       ZDATE
     C                   MOVE      *BLANKS       UPVDX
     C     ErrorFound    IFEQ      'N'
     C     SUPVD         ANDNE     *BLANKS
                                                                                167511
     C*******************MOVE      SUPVD         ZDATE                          167511
                                                                                167511
     C                   TESTN                   SUPVD                9798      167511
     C     *IN97         IFEQ      '1'                                          167511
     C     *IN98         OREQ      '1'                                          167511
     C                   CALLB     'ZDATE1'
     C*******************PARM                    STNICD                         167511
     C                   PARM                    SUPVD                          167511
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
     C                   ENDIF                                                  167511
                                                                                167511
     C     ErrorFlag     IFEQ      'Y'
     C     *IN97         OREQ      '0'                                          167511
     C     *IN98         ANDEQ     '0'                                          167511
     C                   MOVE      'MMA0067'     Msgid1
     C                   MOVE      'N'           ErrorFlag
     C                   MOVE      'Y'           ErrorFound
     C                   ELSE
     C                   MOVE      ZDAYNO        UPVDX             5 0
     C     UPVDX         IFLT      DDATX
     C     UPVDX         ORGE      MDATX
     C                   MOVE      'MMA0068'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   END
     C                   END
 
     C*****VDATXok       IFEQ      'Y'                                          167511
     C     VDATXok       IFNE      'N'                                          167511
     C     ErrorFound    ANDEQ     'N'
     C     UPVDX         ANDGT     VDATX
     C                   MOVE      'MMA0069'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   END
 
      ** If Deal Ccy code is valid
 
     C*****SUCUCYok      IFEQ      'Y'                                          167511
     C     SUCUCYok      IFNE      'N'                                          167511
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SUCUCY        @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Warning if value date is a holiday for the equivalent CCY.
 
     C     SBYSL         IFEQ      'B'
     C     SPSETM        IFEQ      '01'
     C     SPSETM        OREQ      '02'
     C     SPSETM        OREQ      '07'
     C     SPSETM        OREQ      '08'
     C     SPSETM        OREQ      '12'
     C                   MOVE      SUCUCY        ZCCY
     C                   Z-ADD     UPVDX         ZDAYNO
     C                   MOVE      BJSLCD        ZLOC
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    ZIND
 
      ** If the date is a holiday
 
     C     ZIND          IFEQ      'H'
 
      * Avoid exceeding size of error code array.
 
     C                   MOVE      'MMA0070'     WMsgid1
     C                   EVAL      WarnFound    = 'Y'                           167511
     C*******************MOVE      'Y'           ErrorFound                     167511
     C                   END
     C                   ELSE
     C                   MOVE      BJLCCY        ZCCY
     C                   Z-ADD     UPVDX         ZDAYNO
     C                   MOVE      BJSLCD        ZLOC
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    ZIND
 
      ** If the date is a holiday
 
     C     ZIND          IFEQ      'H'
     C                   MOVE      'MMA0071'     WMsgid2
     C                   EVAL      WarnFound    = 'Y'                           167511
     C*******************MOVE      'Y'           ErrorFound                     167511
     C                   END
     C                   END
     C                   END
     C     SBYSL         IFEQ      'S'
     C     SRSETM        IFEQ      '01'
     C     SRSETM        OREQ      '02'
     C     SRSETM        OREQ      '07'
     C     SRSETM        OREQ      '08'
     C     SRSETM        OREQ      '12'
     C                   MOVE      SUCUCY        ZCCY
     C                   Z-ADD     UPVDX         ZDAYNO
     C                   MOVE      BJSLCD        ZLOC
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    ZIND
 
      ** If the date is a holiday
 
     C     ZIND          IFEQ      'H'
 
      * Avoid exceeding size of error code array.
 
     C                   MOVE      'MMA0070'     WMsgid1
     C                   EVAL      WarnFound    = 'Y'                           167511
     C*******************MOVE      'Y'           ErrorFound                     167511
     C                   END
     C                   ELSE
     C                   MOVE      BJLCCY        ZCCY
     C                   Z-ADD     UPVDX         ZDAYNO
     C                   MOVE      BJSLCD        ZLOC
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    ZIND
 
      ** If the date is a holiday
 
     C     ZIND          IFEQ      'H'
 
      * Avoid exceeding size of error code array.
 
     C                   MOVE      'MMA0071'     WMsgid2
     C                   EVAL      WarnFound    = 'Y'                           167511
     C*******************MOVE      'Y'           ErrorFound                     167511
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C/COPY WNCPYSRC,DL1604IC30
     C*
      *
      /SPACE 4
     C*******************IF        ErrorFound = 'Y'                             167511
     C*******************EVAL      RetCodeIn = 'Error'                          167511
     C*******************ENDIF                                                  167511
                                                                                167511
      ** The return code is set in the following /COPY:                         167511
     C/COPY ZACPYSRC,SETRETCDE                                                  167511
                                                                                167511
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
     C                   PARM                    ReturnCode                     167511
     C*******************PARM                    RetCodeIn                      167511
     C                   PARM                    Msgid1
     C                   PARM                    WMsgid1
     C                   PARM                    WMsgid2
     C                   PARM                    CIR001
     C                   PARM                    BJDFIN
     C                   PARM                    DDATXok
     C                   PARM                    VDATXok
     C                   PARM                    MDATXok
     C                   PARM                    SUCUCYok
     C                   PARM                    STNICD
     C                   PARM                    SUPVD
     C                   PARM                    SUPFE
     C                   PARM                    SBYSL
     C                   PARM                    SPSETM
     C                   PARM                    BJSLCD
     C                   PARM                    BJLCCY
     C                   PARM                    SUCUCY
     C                   PARM                    VDATX
     C                   PARM                    MDATX
     C                   PARM                    DDATX
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
