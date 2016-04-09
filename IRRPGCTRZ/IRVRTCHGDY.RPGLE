     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR: Validate Rate Change Day in Month')          *
      *****************************************************************
      *                                                               *
      *  Midas - Validate rate change frequency                       *
      *                                                               *
      *  IRVRTCHGDY                                                   *
      *                                                               *
      *  Function:  This module validates the rate change day.        *
      *             If it is valid, the return indicator contains     *
      *             'Error', else it is blank.                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CIR018             Date 06Aug14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *  Prev Amend No. CIR007             Date 11May01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 01Feb98               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CIR018 - Daily Rate Change Frequency on SIRS                 *
      *  CIR007 - Overnight Index Swaps                               *
      *  CAP003 - Conversion of IR inputs into modular structure to   *
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 CIR018
      ** External DS for SAR details                                                         CIR018
                                                                                             CIR018
     D DSFDY         E DS                  EXTNAME(DSFDY)                                    CIR018
      ** External data structure for access programs (short)                                 CIR018
 
      ** ZDAYNO data area to extract ZDAY
     D DateDS          DS             6
     D ZMTH                    1      2  0
     D ZDAY                    3      4  0
     D ZYR                     5      6  0
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * rate change date
     D SUNICD          S              6A
 
      * rate change day in month
     D SUICFD          S              2A
 
      * rate change frequency
     D SUICFR          S              1A
 
      * work field for rate change day.
     D UICFDX          S              2S 0
 
      * valid rate change date passed as parameter.
     D UNICDX          S              5  0
 
      *  Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
 
      *  A 16 character alphanumeric field to contain numeric input
      *  The field may contain leading and trailing blanks and a
      *  decimal point,and may have up to 15 digits.
     D ZFIELD          S             16A
 
      *  contains the required number of digits before the decimal
      *  point as a constant.
     D ZADEC           S              1P 0
 
      * contains required number of digits before the decimal point as
      * a constant in program.
     D ZADIG           S              2P 0
 
      * returns 'Y' or 'N' depending on whether validation has been successful
     D ZALIGNok        S              1A
 
      ** Date format indicator used passed from calling program as parameter
     D  BJDFIN         S              1A
 
      ** Day number passed back to calling program
     D  ZDAYX          S              2  0
 
      ** Deal Type used as Parameter                                                          CIR007
     DPDealTyp         S              2A                                                      CIR007
                                                                                              CIR007
      ** OVERNIGHT INDEX SWAPS                                                                CIR007
     DCIR007           S              1A                                                      CIR007
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
 
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
     C                   MOVE      *OFF          *IN49
 
      ** If CIR007 is on , Deal Type is 'RS' and Rate Change Frequency                        CIR007
      ** Code is 'O', then the Rate Change Day must be blank.                                 CIR007
                                                                                              CIR007
     C                   IF        CIR007 = 'Y' AND PDealTyp = 'RS'                           CIR007
     C                             AND SUICFR = 'O'                                           CIR007
     C                   IF        SUICFD <> *BLANKS                                          CIR007
     C                   MOVE      'Y'           ErrorFound                                   CIR007
     C                   MOVE      'MMA1178'     Msgid1                                       CIR007
     C                   ENDIF                                                                CIR007
                                                                                              CIR007
     C                   ElSE                                                                 CIR007
                                                                                              CIR007
      ** Validate Our Rate Change Frequency Day in Month Using ZALIGN.
 
     C                   Z-ADD     0             UICFDX
     C     SUICFD        IFNE      *BLANKS
     C     SUICFR        IFEQ      *BLANK
     C                   MOVE      'MMA0030'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   ELSE
     C     ErrorFound    IFEQ      'N'
      *                                                                                       CIR018
     C                   If        CIR018 = 'Y' and PDealTyp = 'RS'                           CIR018
     C                             and SUICFD <> *Blanks and                                  CIR018
     C                             SUICFR = 'D'                                               CIR018
     C                   move      '5047298'     Msgid1                                       CIR018
     C                   move      'Y'           ErrorFound                                   CIR018
     C                   else                                                                 CIR018
      *                                                                                       CIR018
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     2             ZADIG
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SUICFD        ZFIELD
     C                   MOVE      'N'           ZAOPT             1
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        UICFDX
     C                   END
      *
     C     ZALIGNok      IFEQ      'N'
     C     UICFDX        ORLT      1
     C     UICFDX        ORGT      31
     C                   MOVE      'MMA0031'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'N'           ZALIGNok
     C                   END
     C                   Endif                                                                CIR018
     C                   END
     C                   END
     C                   END
     C     SUICFD        IFEQ      *BLANKS                                                     S0115
     C     SUICFR        ANDNE     *BLANKS                                                     S0115
     C     UNICDX        ANDNE     0                                                           S0115
     C     CIR018        ANDEQ     'N'                                                        CIR018
     C     SUICFD        Oreq      *BLANKS                                                    CIR018
     C     SUICFR        andne     *BLANKS                                                    CIR018
     C     UNICDX        andne     0                                                          CIR018
     C     CIR018        andeq     'Y'                                                        CIR018
     C     SUICFR        andne     'D'                                                        CIR018
     C                   MOVEL     SUNICD        DateDS
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      ZDAY          ZDAYX
     C                   Z-ADD     ZDAY          UICFDX                                        S0115
     C                   ELSE
     C                   MOVE      ZMTH          ZDAYX
     C                   Z-ADD     ZMTH          UICFDX                                        S0115
     C                   ENDIF
     C                   END                                                                   S0115
                                                                                              CIR007
     C                   ENDIF                                                                CIR007
 
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
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
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    SUICFR
     C                   PARM                    SUNICD
     C                   PARM                    SUICFD
      * This is used in the collars, caps and floors call - otherwise
      * pass a non-zero number to this module.
     C                   PARM                    UNICDX
     C                   PARM                    ZDAYX
     C                   PARM                    UICFDX
     C                   PARM                    PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007
                                                                                              CIR018
      ** Access SAR details file to determine if CIR018 is switched on                        CIR018
                                                                                              CIR018
     C                   CALL      'AOSARDR0'                                                 CIR018
     C                   PARM      *BLANKS       @RTCD                                        CIR018
     C                   PARM      '*VERIFY'     @OPTN                                        CIR018
     C                   PARM      'CIR018'      @SARD                                        CIR018
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR018
                                                                                              CIR018
     C                   IF        (@RTCD <> *BLANKS) And (@RTCD <> '*NRF   ')                CIR018
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CIR018
     C                   MOVEL     '001'         DBASE                                        CIR018
     C                   MOVEL     'CIR018'      DBKEY                                        CIR018
     C                   EXSR      *PSSR                                                      CIR018
     C                   ENDIF                                                                CIR018
                                                                                              CIR018
     C                   IF        @RTCD = *BLANKS                                            CIR018
     C                   MOVEL     'Y'           CIR018            1                          CIR018
     C                   ELSE                                                                 CIR018
     C                   MOVEL     'N'           CIR018                                       CIR018
     C                   ENDIF                                                                CIR018
                                                                                              CIR018
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
