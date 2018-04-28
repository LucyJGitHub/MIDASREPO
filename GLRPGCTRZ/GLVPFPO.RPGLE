     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate profit centre and portfolio ref.')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVPFPO    - Validate Profit Centre & Portfolio Reference    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. 249245             Date 25Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 178695             Date 29Jun00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CPB001             Date 18Oct99               *
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249245 - Applied fix 225809.                                 *
      *  225809 - Allow removal of profit centre for GL accounts in   *
      *           amend mode even if Profit centre is not amendable   *
      *           in GL ICD.  Profit centre is only mandatory for     *
      *           Retail and Nostro accounts.                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase account code to 10 digits                  *
      *  178695 - Review some validation with 'PB' Module             *
      *           in Account Maintenance Processing                   *
      *  CPB001 - 'Private Banking' Module                            *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
     FPMPORTLL  IF   E           K DISK    INFSR(*PSSR)
     FACCPTFR   IF   E           K DISK    INFSR(*PSSR)                         178695
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Input parameters on call to AOPLCSR1
     D I@PARM          DS           256
     D  I#PORS                 1      1
     D  I#R997                 2      5
     D  I#CUST                 6     15
     D  I#BRCA                16     18
     D  I#BOOK                19     20
     D  I#PTFR                21     24
     D  I#CPGM                25     34
      *
      ** Output parameters on call to AOPLCSR1
     D O@PARM          DS           256
     D  O#BOOK                 1      2
     D  O#PTFR                 3      6
     D  O#BICN                 7     12
     D  O#CRNM                13     22
     D  O#ACOF                23     24
 
      ** External data structure for customer details file
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External data structure for profit centres file
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
 
      ** External data structure for account codes file
     D SDACOD        E DS                  EXTNAME(SDACODPD)
 
      ** External data structure for portfolio management customer dtl file
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
 
      ** External data structure for portfolio lending customer detail file
     D SDLBCS        E DS                  EXTNAME(SDLBCSPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for access programs (long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                CPB001
      ** External data structure for access programs (very long)                CPB001
     D DSLDY         E DS                  EXTNAME(DSLDY)                       CPB001
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
                                                                                              CGL029
     D @ACOD           S             10                                                       CGL029
     D DDACOD          S             10                                                       CGL029
     D WWACOD          S             10  0                                                    CGL029
 
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
 
      ** Initialization
 
     C                   Movel     *Blanks       RetCodeIn
     C                   Movel     *Blanks       FldNamXAr
     C                   Movel     *Blanks       MsgIDXAr
     C                   Movel     *Blanks       MsgDtaXAr
     C                   Z-add     0             Idx
      *
     C                   EXSR      SRINIT
      *
     C                   ExSr      SrVPRFC
      *
     C                   ExSr      SrVPTFR
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDPRFCOK      IfEq      'N'
     C     DDPTFROK      OrEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrVPRFC - Validate Profit Centre                             *
      *****************************************************************
     C     SrVPRFC       BEGSR
      *
     C     BKPRCU        IFEQ      'Y'
     C                   SELECT
      *
      ** amend mode but change not allowed
      ** Allow PRFC field to be blank even if the 'Profit Centre Amendable'                   225809
      ** ICD flag is on.  This is for account type of 'G' only.                               225809
      *                                                                                       225809
     C     DDACTN        WHENEQ    'A'
     C     DDPRFC        ANDNE     AMPRFC
     C     BKPRCA        ANDNE     'Y'
      *                                                                                       225809
     C     AMATYP        IFEQ      'R'                                                        225809
     C     AMATYP        OREQ      'N'                                                        225809
      *                                                                                       225809
     C     AMATYP        ORNE      'R'                                                        225809
     C     AMATYP        ANDNE     'N'                                                        225809
     C     DDPRFC        ANDNE     *BLANKS                                                    225809
     C                   Move      'N'           DDPRFCOK
     C                   Add       1             Idx
     C                   Movel     'DDPRFC'      FldNamXAr(Idx)
     C                   Movel     'RE71120'     MsgIdXAr(Idx)
     C                   ENDIF                                                                225809
      *
      ** insert mode and no entry made, get default if this is used
      ** and if analytical accounting module is switched off
      *
     C     DDACTN        WHENEQ    'I'
     C     DDPRFC        ANDEQ     *BLANKS
     C     BKPCDU        ANDEQ     'Y'
     C     BGN0ST        ANDEQ     'N'
      *
      **  or no entry made and analytical accounting is switched on,
      **  get profit centre default for retail and nostro a/cs only
      *
     C     DDPRFC        OREQ      *BLANKS
     C     BGN0ST        ANDEQ     'Y'
     C     AMATYP        ANDEQ     'R'
      *
     C     DDPRFC        OREQ      *BLANKS
     C     BGN0ST        ANDEQ     'Y'
     C     AMATYP        ANDEQ     'N'
      *
      * Set up account officer from the customer of the account.
      *
     C*****              CALL      'AOCUSTR0'                                   178695
     C                   CALL      'AOCUSTR1'                                   178695
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCUSN        @CNUM            10
     C                   PARM                    @CNST             7
     C*****SDCUST        PARM      SDCUST        DSSDY                          178695
     C     SDCUST        PARM      SDCUST        DSLDY                          178695
      *
     C     @RTCD         IFNE      *BLANKS
     C                   Add       1             Idx
     C                   Movel     *Blanks       FldNamXAr(Idx)
     C                   Movel     'RE71022'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   CALL      'AOPRFMR0'
     C                   PARM      *BLANKS       RTCDPR            1
     C                   PARM      *BLANKS       BOOKPR            2
     C                   PARM      *BLANKS       TRTPPR            5
     C                   PARM      *BLANKS       SUTPPR            2
     C                   PARM      DDBRCA        BRANPR            3
     C                   PARM      *BLANKS       DEPTPR            3
     C                   PARM      PSUSER        USERPR           10
     C                   PARM      BBACOC        ACOFPR            2
     C                   PARM      DDCUSN        CNUMPR            6
     C     DDPRFC        PARM                    PRFCPR            4
      *
     C     RTCDPR        IFEQ      '2'
     C                   Move      'N'           DDPRFCOK
     C                   Add       1             Idx
     C                   Movel     'DDPRFC'      FldNamXAr(Idx)
     C                   Movel     'RE71121'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      **  If accounting module is switched on and default profit centre
      **  is still blank for retail or nostro a/c, send error msg
      *
     C     BGN0ST        IFEQ      'Y'
     C     DDPRFC        ANDEQ     *BLANKS
      *
     C     AMATYP        IFEQ      'R'
     C     AMATYP        OREQ      'N'
     C                   Move      'N'           DDPRFCOK
     C                   Add       1             Idx
     C                   Movel     'DDPRFC'      FldNamXAr(Idx)
     C                   Movel     'RE71123'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
      * validate if entered
     C     DDPRFC        WHENNE    *BLANKS
      *
      **  If accounting module is switched on, allow entry for retail
      **  and nostro accounts only.
      *
     C     BGN0ST        IFEQ      'N'
     C     BGN0ST        OREQ      'Y'
     C     AMATYP        ANDEQ     'R'
     C     BGN0ST        OREQ      'Y'
     C     AMATYP        ANDEQ     'N'
      *
     C                   CALL      'AOPRFCR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      DDPRFC        @KEY              4
     C     SDPRFC        PARM      SDPRFC        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   Move      'N'           DDPRFCOK
     C                   Add       1             Idx
     C                   Movel     'DDPRFC'      FldNamXAr(Idx)
     C                   Movel     'RE71121'     MsgIdXAr(Idx)
     C                   ELSE
     C                   MOVE      DSPCCD        DDPRFC
     C                   ENDIF
      *
      **  Else, entry is prohibited so send error message
     C                   ELSE
     C                   Move      'N'           DDPRFCOK
     C                   Add       1             Idx
     C                   Movel     'DDPRFC'      FldNamXAr(Idx)
     C                   Movel     'RE71123'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDSL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrVPTFR - Validate Portfolio Reference                       *
      *****************************************************************
     C     SrVPTFR       BEGSR
      *
      ** Account Code must be live
     C                   CALL      'AOACODR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C**********         PARM      DDACOD        @ACOD             4                          CGL029
     C*****SDACOD        PARM      SDACOD        DSFDY                                        CGL029
     C                   PARM      DDACOD        @ACOD                                        CGL029
     C     SDACOD        PARM      SDACOD        DSSDY                                        CGL029
      *
     C     @RTCD         IFNE      *BLANK
     C                   Move      'N'           DDACODOK
     C                   Add       1             Idx
     C                   Movel     'DDACOD'      FldNamXAr(Idx)
     C                   Movel     'RE71037'     MsgIdXAr(Idx)
     C                   END
      *
      ** Validate Portfolio Reference only if module present
     C**** BGPFMG        IFEQ      'Y'                                          CPB001
     C**** *IN38         ANDEQ     *OFF                                         CPB001
     C     BGPFMG        IFEQ      'Y'                                          CPB001
     C     *IN38         ANDEQ     *OFF                                         CPB001
     C     BGN4ST        OREQ      'Y'                                          CPB001
     C     *IN38         ANDEQ     *OFF                                         CPB001
      *
     C     BGPFMG        IFEQ      'Y'                                          CPB001
     C                   MOVEL     DDCUSN        I#CUST
     C                   MOVEL     DDBRCA        I#BRCA
     C                   MOVEL     DDPTFR        I#PTFR
     C                   MOVEL     *BLANKS       I#BOOK
     C******IN38         IFEQ      *ON                                          178695
     C                   MOVEL     *BLANKS       I#CPGM
     C******             ELSE                                                   178695
     C******             MOVEL     'GL3271'      I#CPGM                         178695
     C******             ENDIF                                                  178695
      *
     C                   CALL      'AOPLCSR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    I@PARM
     C                   PARM      *BLANKS       O@PARM
     C     SDPLCS        PARM      SDPLCS        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C     @RTCD         OREQ      'PMA0010'
     C     O#PTFR        ANDEQ     I#R997
     C*
     C     DDPTFR        IFEQ      *BLANK
     C     AMATYP        ANDEQ     'R'
     C     DDACTN        ANDNE     'I'
     C*
     C     DDPTFR        OREQ      *BLANK
     C     AMATYP        ANDEQ     'N'
     C     DDACTN        ANDNE     'I'
     C     FCPORS        ANDEQ     'B'
     C*
     C     DDPTFR        OREQ      *BLANK
     C     A5ACTY        ANDEQ     'R'
     C     DDACTN        ANDEQ     'I'
     C*
     C     DDPTFR        OREQ      *BLANK
     C     A5ACTY        ANDEQ     'N'
     C     DDACTN        ANDEQ     'I'
     C     FCPORS        ANDEQ     'B'
     C*
     C     BGN4ST        IFNE      'Y'                                          CPB001
     C                   MOVE      O#PTFR        DDPTFR
     C                   ENDIF                                                  CPB001
     C                   END
     C*
      * If PM customer, the account code should have
      * a valid instrument type, if you want to associate a portfolio ref.
      * to the account.
     C     A5INNR        IFEQ      *BLANKS
     C     DDPTFR        ANDNE     *BLANKS
     C                   Move      'N'           DDPTFROK
     C                   Add       1             Idx
     C                   Movel     'DDPTFR'      FldNamXAr(Idx)
     C                   Movel     'RE71122'     MsgIdXAr(Idx)
     C                   ENDIF
     C*
     C                   END
     C*
     C     @RTCD         IFNE      *BLANKS
     C     *IN38         ANDEQ     *OFF
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C                   MOVEL     O#PTFR        DDPTFR
     C                   Move      'N'           DDPTFROK
     C                   ENDIF
     C                   ENDIF                                                  CPB001
      *                                                                         CPB001
     C     BGN4ST        IFEQ      'Y'                                          CPB001
     C     A5ACTY        ANDEQ     'R'                                          CPB001
     C     DDPTFR        ANDEQ     *BLANKS                                      CPB001
     C                   MOVE      CUST          WWCNUM                         178695
     C                   MOVE      DDCCY         WWCCY                          178695
     C                   MOVE      DDACOD        WWACOD                         178695
     C                   MOVE      DDACSQ        WWACSQ                         178695
     C                   MOVE      'N'           WWVAL             1            178695
     C     CUST          SETLL     PMPORTLL                                     CPB001
     C     CUST          READE     PMPORTLL                               80    CPB001
     C     *IN80         DOWEQ     *OFF                                         178695
     C     WWVAL         ANDEQ     'N'                                          178695
      *                                                                         178695
     C     PNDPCL        IFEQ      0                                            178695
     C                   MOVE      PNPTFR        WWPTFR            4            178695
     C     PTFRK         CHAIN     ACCPTFR                            81        178695
      *                                                                         178695
     C     *IN81         IFEQ      '0'                                          178695
     C     CUST          READE     PMPORTLL                               80    178695
     C                   ELSE                                                   178695
     C                   MOVE      PNPTFR        DDPTFR                         178695
     C                   MOVE      'Y'           WWVAL                          178695
     C                   ENDIF                                                  178695
      *                                                                         178695
     C                   ELSE                                                   178695
     C     CUST          READE     PMPORTLL                               80    178695
     C                   ENDIF                                                  178695
     C                   ENDDO                                                  178695
      *                                                                         178695
     C     DDPTFR        IFEQ      *BLANKS                                      178695
     C                   Move      'N'           DDPTFROK                       178695
     C                   Add       1             Idx                            178695
     C                   Movel     'DDPTFR'      FldNamXAr(Idx)                 178695
     C                   Movel     'RE71117'     MsgIdXAr(Idx)                  178695
     C                   ENDIF                                                  178695
      *                                                                         178695
     C                   ELSE                                                   178695
     C                   MOVE      CUST          WWCNUM                         178695
     C                   MOVE      DDCCY         WWCCY                          178695
     C                   MOVE      DDACOD        WWACOD                         178695
     C                   MOVE      DDACSQ        WWACSQ                         178695
     C                   MOVE      DDPTFR        WWPTFR                         178695
     C     PTFRK         CHAIN     ACCPTFR                            81        178695
      *                                                                         178695
     C     *IN81         IFEQ      '0'                                          178695
     C     DDACTN        ANDEQ     'I'                                          178695
     C                   Move      'N'           DDPTFROK                       178695
     C                   Add       1             Idx                            178695
     C                   Movel     'DDPTFR'      FldNamXAr(Idx)                 178695
     C                   Movel     'RE71023'     MsgIdXAr(Idx)                  178695
     C                   ENDIF                                                  178695
     C******IN80         IFEQ      *OFF                                  CPB001 178695
     C******             MOVE      PNPTFR        DDPTFR                  CPB001 178695
     C******             ENDIF                                           CPB001 178695
     C                   ENDIF                                                  CPB001
      *
      ** - When DDPTFR entered
      ** - - DDPTFR must be live on PMPORTPD
     C     DDPTFR        IFNE      *BLANK
     C     DDPTFR        ANDNE     FCR997
     C     DDPTFR        ORNE      *BLANK                                       CPB001
     C     BGN4ST        ANDEQ     'Y'                                          CPB001
     C     DDPTFR        OREQ      *BLANK                                       CPB001
     C     BGN4ST        ANDEQ     'Y'                                          CPB001
     C     A5ACTY        ANDEQ     'R'                                          CPB001
     C     DDPTFR        OREQ      *BLANK                                       CPB001
     C     BGPFMG        ANDEQ     'Y'                                          CPB001
     C     A5ACTY        ANDEQ     'R'                                          CPB001
     C     BGN4ST        IFEQ      'Y'                                          CPB001
     C                   MOVEL     DDCUSN        CUST                           CPB001
     C                   ELSE                                                   CPB001
     C**********         MOVEL     QBCUST        CUST              6 0                        CSD027
     C                   MOVEL     QBCUST        CUST              6                          CSD027
     C                   ENDIF                                                  CPB001
     C                   MOVE      DDPTFR        PREF              4
     C     POKEY         CHAIN     PMPORTLL                           80
     C     *IN80         IFEQ      '1'
     C                   Move      'N'           DDPTFROK
     C                   Add       1             Idx
     C                   Movel     'DDPTFR'      FldNamXAr(Idx)
     C                   Movel     'RE71117'     MsgIdXAr(Idx)
     C                   END
     C*
     C     PNDPCL        IFNE      *ZERO
     C     FLAG          IFEQ      *BLANK
     C                   MOVE      'Y'           FLAG              1
     C                   Move      'N'           DDPTFROK
     C                   Add       1             Idx
     C                   Movel     'DDPTFR'      FldNamXAr(Idx)
     C                   Movel     'RE71118'     MsgIdXAr(Idx)
     C                   END
     C                   END
     C                   END
      *
      ** Error if current Portfolio Reference refers to a Portfolio
      ** for which performance already started.
     C     DDACTN        IFEQ      'A'
     C     DDPTFR        ANDNE     AMPTFR
     C     AMPTFR        ANDNE     FCR997
     C     WSPSDT        ANDLT     BJRDNB
     C     WSPSDT        ANDNE     0
     C     DDPTFROK      ANDEQ     'Y'
     C                   Move      'N'           DDPTFROK
     C                   Add       1             Idx
     C                   Movel     'DDPTFR'      FldNamXAr(Idx)
     C                   Movel     'RE71872'     MsgIdXAr(Idx)
     C                   END
      *
      ** Error if new Portfolio Reference entered refers to a Portfolio
      ** for which performance already started
     C     DDACTN        IFEQ      'A'
     C     DDPTFR        ANDNE     AMPTFR
     C     DDPTFR        ANDNE     FCR997
     C     PNPSDT        ANDLT     BJRDNB
     C     DDPTFROK      ANDEQ     'Y'
     C                   Move      'N'           DDPTFROK
     C                   Add       1             Idx
     C                   Movel     'DDPTFR'      FldNamXAr(Idx)
     C                   Movel     'RE71873'     MsgIdXAr(Idx)
     C                   END
     C                   END
     C*
     C     BGLMCR        IFEQ      'Y'
     C*
     C** Check if a Portfolio Lending Customer
     C*
     C                   CALL      'AOLBCSR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCUSN        @CUSN            10
     C     SDLBCS        PARM      SDLBCS        DSFDY
     C*
     C     @RTCD         IFEQ      *BLANK
     C*
     C** If LB customer and retail account, the account code should
     C** have a valid instrument type
     C*
     C     A5INNR        IFEQ      *BLANKS
     C     A5ACTY        ANDEQ     'R'
     C     A5INNR        OREQ      *BLANKS
     C     AMATYP        ANDEQ     'R'
     C                   Move      'N'           DDPTFROK
     C                   Add       1             Idx
     C                   Movel     'DDPTFR'      FldNamXAr(Idx)
     C                   Movel     'RE71122'     MsgIdXAr(Idx)
     C                   ENDIF
     C*
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINIT - Process Initialisation                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
     C     BGPFMG        IFEQ      'Y'                                          CPB001
     C                   MOVEL     DDCUSN        I#CUST
     C                   MOVEL     DDBRCA        I#BRCA
     C                   MOVEL     *BLANKS       I#PTFR
     C                   MOVEL     *BLANKS       I#CPGM
     C                   MOVEL     FCPORS        I#PORS
     C                   MOVEL     FCR997        I#R997
     C                   MOVEL     *BLANKS       I#BOOK
      *
     C                   CALL      'AOPLCSR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    I@PARM
     C                   PARM      *BLANKS       O@PARM
     C     SDPLCS        PARM      SDPLCS        DSFDY
      *
     C     @RTCD         IFEQ      'PMA0008'
     C     @RTCD         OREQ      'PMA0009'
      *
     C     DDACTN        ORNE      'I'
     C     I#PORS        ANDNE     'B'
     C     AMATYP        ANDNE     'R'
      *
     C     DDACTN        ORNE      'I'
     C     I#PORS        ANDEQ     'B'
     C     AMATYP        ANDNE     'R'
     C     AMATYP        ANDNE     'N'
      *
     C     DDACTN        OREQ      'I'
     C     I#PORS        ANDNE     'B'
     C     A5ACTY        ANDNE     'R'
      *
     C     DDACTN        OREQ      'I'
     C     I#PORS        ANDEQ     'B'
     C     A5ACTY        ANDNE     'R'
     C     A5ACTY        ANDNE     'N'
      *
     C                   MOVE      *ON           *IN38
     C                   ELSE
     C                   MOVE      *OFF          *IN38
     C                   ENDIF
     C                   ENDIF                                                  CPB001
      *
     C     BGN4ST        IFEQ      'Y'                                          CPB001
     C                   CALL      'AOCUSTR1'                                   CPB001
     C                   PARM      '*MSG   '     @RTCD                          CPB001
     C                   PARM      '*KEY   '     @OPTN                          CPB001
     C                   PARM      DDCUSN        @CNUM            10            CPB001
     C                   PARM                    @CNST             7            CPB001
     C     SDCUST        PARM      SDCUST        DSLDY                          CPB001
      *                                                                         CPB001
     C     @RTCD         IFEQ      *BLANKS                                      CPB001
     C     BBPRBA        ANDEQ     'Y'                                          CPB001
     C                   MOVE      *OFF          *IN38                          CPB001
     C                   ELSE                                                   CPB001
     C     BGPFMG        IFNE      'Y'                                          CPB001
     C                   MOVE      *ON           *IN38                          CPB001
     C                   ENDIF                                                  CPB001
     C                   ENDIF                                                  CPB001
     C                   ENDIF                                                  CPB001
      *                                                                         CPB001
     C     BGN4ST        IFEQ      'Y'                                          CPB001
     C                   MOVEL     DDCUSN        CUST                           CPB001
     C                   ELSE                                                   CPB001
     C                   MOVEL     QBCUST        CUST
     C                   ENDIF                                                  CPB001
     C                   MOVE      AMPTFR        PREF
     C     POKEY         CHAIN     PMPORTLL                           80
     C     *IN80         IFEQ      '0'
     C                   Z-ADD     PNPSDT        WSPSDT            5 0
     C                   ELSE
     C                   Z-ADD     0             WSPSDT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        Plist
      *
      ** INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** Account Screen fields
     C                   Parm                    DDACTN            1
     C                   Parm                    DDBRCA            3
     C                   Parm                    DDCUSN            6
     C                   Parm                    DDCCY             3
     C**********         Parm                    DDACOD            4                          CGL029
     C                   Parm                    DDACOD                                       CGL029
     C                   Parm                    DDACSQ            2
     C                   Parm                    DDPRFC            4
     C                   Parm                    DDPTFR            4
      *
     C                   Parm                    AMPRFC            4
     C                   Parm                    AMPTFR            4
     C                   Parm                    AMATYP            1
      *
      ** ICD
     C                   Parm                    BKPRCU            1
     C                   Parm                    BKPRCA            1
     C                   Parm                    BKPCDU            1
     C                   Parm                    BGN0ST            1
     C                   Parm                    BGPFMG            1
     C                   Parm                    BGLMCR            1
     C                   Parm                    BJRDNB            5 0
     C                   Parm                    FCPORS            1
     C                   Parm                    FCR997            4
     C                   Parm                    BGN4ST            1            CPB001
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
      ** Profit Centre - Ok
      ** Portfolio Reference - Ok
      ** Account Code - Ok
     C                   Parm                    DDPRFCOk          1
     C                   Parm                    DDPTFROk          1
     C                   Parm                    DDACODOk          1
      *
      **  DEfine key list to access PMPORTLL
     C     POKEY         KLIST
     C                   KFLD                    CUST
     C                   KFLD                    PREF
      *                                                                         178695
      **  DEfine key list to access ACCPTFR                                     178695
     C     PTFRK         KLIST                                                  178695
     C                   KFLD                    WWPTFR            4            178695
     C**********         KFLD                    WWCNUM            6 0                 178695 CSD027
     C                   KFLD                    WWCNUM            6                          CSD027
     C                   KFLD                    WWCCY             3            178695
     C**********         KFLD                    WWACOD            4 0                 178695 CGL029
     C                   KFLD                    WWACOD                                       CGL029
     C                   KFLD                    WWACSQ            2 0          178695
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
