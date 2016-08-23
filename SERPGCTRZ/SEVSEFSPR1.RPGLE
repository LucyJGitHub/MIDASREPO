     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Securities Prices (Ex Interest)')    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SEVSEFSPR1 - Validate Securities Prices Excluding Interest   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 03May06               *
      *                 BUG11164           Date 06Apr06               *
      *                 236137             Date 20Sep05               *
      *                 234675             Date 05Jul05               *
      *                 234440             Date 21Jun05               *
      *                 234008             Date 10Jun05               *
      *                 233698             Date 25May05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  BUG11164 - A Serious Midas Error on SETRAD insert/amend      *
      *  236137 - Change Control for CGL031 Parts 4 & 5.              *
      *           Several changes in the Taxation of Savings Income   *
      *           functionality.                                      *
      *           - Choice of calculation method for fiscal price     *
      *           must take in account Tax Calculation Basis          *
      *           indicator from Country of Tax Codes file SDCTTXPD.  *
      *  234675 - Change control for processing type 4 and Dividend   *
      *           EU tax calculation.                                 *
      *  234440 - Change Control 1 Part 4 - For Switzerland only,     *
      *           bonds at at a discount will have their fiscal price *
      *           calculated on a yield curve.                        *
      *  234008 - Price Input for funds defaulting mechanism          *
      *  233698 - Change Control for CGL031                           *
      *  CGL031 - Taxation of Savings Income.                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Security Details
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
 
      ** Investment Type
     FINVTP     IF   E           K DISK    INFSR(*PSSR)
                                                                                              234008
     FSECEO     IF   E           K DISK    INFSR(*PSSR)                                       234008
     F                                     RENAME(SNDEVDF:SNDEVDO)                            234008
 
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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
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
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter and work variable declarations
      ** ------------
     D WPROT           S              1A
     D WTYPE           S              1A
     D WSITP           S              3A
     D WNMCY           S              3A
     D WISSP           S             15P 8
     D WISSD           S              5P 0
     D WMATY           S              5P 0
 
     D ZINDAT          S              5P 0
     D ZIBDAT          S              5P 0
     D ZIFDAT          S              5P 0
     D ZINRAT          S             15P 8
     D ZIFRAT          S             15P 8
     D ZIBRAT          S             15P 8
 
     D ZRTN            S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
 
     D PRtcd           S              7A
     D POptn           S              7A
                                                                                              236137
      ** Specific parameters for AOCTTXR0                                                     236137
      ** --------------------------------                                                     236137
     D PCtrt           S              2A                                                      236137
     D PCtrr           S              2A                                                      236137
 
      ** Input fields
      ** ------------
     D DDPEXI          S             16A
     D DDPPRT          S              2A
     D DDPSSN          S             10A
     D DDPPRC          S             16A
     D DDPVDT          S              6A
 
      ** Output(s) fields
      ** ----------------
     D JPEXI           S             15P 8
     D JPPRC           S             15P 8
     D DDPEXIOK        S              1A
 
      ** Error flag passed to/from ZDATE1
     D ZDAYNO          S              5P 0
     D ErrorFlag       S              1A
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
                                                                                              234008
     D K_SESN          S             10A                                                      234008
     D K_PTYP          S              2A                                                      234008
     D K_PDAT          S              5  0                                                    234008
 
      ** Security Details                                                                     234440
     D SECTYDS       E DS                  EXTNAME(SECTYD)                                    234440
     D   CDDS                183    230                                                       234440
     D   CRDS                231    242                                                       234440
                                                                                              234440
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
      ** External Data Structure for Country of Tax Codes Details.                            236137
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)                                  236137
                                                                                              236137
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
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
     C                   MOVE      *BLANK        FldNamXar
     C                   MOVE      *BLANK        MsgIDXar
     C                   MOVE      *BLANK        MsgDtaXar
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        WTYPE
 
      ** Initialise output fields
 
     C                   MOVEL     *BLANK        JPEXI
 
     C                   EXSR      PEINTV
 
      ** If an error was found, set the return code appropriately
 
     C     DDPEXIOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * PCENTV - Price Excluding Interest Validation
      *****************************************************************
     C     PEINTV        BEGSR
 
      ** Convert the Price from screen to file format
 
     C                   Z-ADD     7             ZADIG
     C                   Z-ADD     8             ZADEC
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDPPRC        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       ZRTN
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
     C                   MOVE      ZFIELD        JPPRC
 
      ** Price Excluding Interest if present, must be validated as a 15,8
      ** numeric field.
 
     C                   IF        DDPEXI <> *Blanks
     C                   Z-ADD     7             ZADIG
     C                   Z-ADD     8             ZADEC
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDPEXI        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       ZRTN
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
      ** Check that PEXI is numeric
 
     C     ZRTN          IFEQ      'N'
     C                   MOVE      'N'           DDPEXIOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXar(Idx) = 'SEA0909'
     C                   EVAL      FldNamXar(Idx) = 'DDPEXI'
     C                   GOTO      EPEINTV
     C                   ELSE
 
      ** If field is OK, move to numeric output field
      ** Check that PEXI is positive.
 
     C                   MOVE      ZFIELD        JPEXI
 
     C     JPEXI         IFLT      0
     C                   MOVE      'N'           DDPEXIOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIdXar(Idx) = 'SEA0910'
     C                   EVAL      FldNamXar(Idx) = 'DDPEXI'
     C                   GOTO      EPEINTV
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** If funds or bonds, price excluding tax must be entered.
      ** Get using the security shortname.
 
     C     DDPSSN        CHAIN     SECTY                              90
 
      ** Database Error
 
     C     *IN90         IFEQ      '1'
     C                   MOVEL     DDPSSN        DBKEY
     C                   MOVEL     'SECTY'       DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   MOVE      SITP          WSITP
     C                   MOVE      NMCY          WNMCY
     C                   MOVE      ISSP          WISSP
     C                   MOVE      ISSD          WISSD
     C                   MOVE      MATY          WMATY
 
      ** Set up key list for Investment Types file
 
     C     PROTKey       KLIST
     C                   KFLD                    WNMCY
     C                   KFLD                    WSITP
 
      ** Get the processing type
 
     C     PROTKey       CHAIN     INVTP                              90
 
      ** Database Error
 
     C     *IN90         IFEQ      '1'
     C                   MOVEL     DDPSSN        DBKEY
     C                   MOVEL     'INVTP'       DBFILE
     C                   MOVEL     '002'         DBASE
     C                   EXSR      *PSSR
     C
     C                   ELSE
     C                   MOVE      PROT          WPROT
 
     C                   ENDIF
     C                   ENDIF
 
     C**********         IF        WPROT = '7'                                                234675
     C                   IF        WPROT = '7' OR                                             234675
     C                             WPROT = '4'AND SETX = 'Y'                                  234675
     C                   MOVE      'F'           WTYPE
     C                   ENDIF
 
     C                   IF        WPROT <> '7' AND
     C                             WPROT <> '4' AND
     C**********                   WPROT <> '2' AND                                           233698
     C**********                   WISSP < 100                                                233698
     C                             WPROT <> '2'                                               233698
     C                   MOVE      'B'           WTYPE
     C                   ENDIF
 
     C                   IF        DDPEXI = *Blanks AND
     C                             DDPPRT = 'V'
 
      ** Default the fiscal price with the price for funds
 
     C                   IF        WTYPE = 'F'
     C**********         EVAL      JPEXI = JPPRC                                              233698
                                                                                              234008
      ** Convert the Price Value Date to midas day number                                     234008
                                                                                              234008
     C                   CALLB     'ZDATE1'                                                   234008
     C                   PARM                    DDPVDT                                       234008
     C                   PARM      *ZEROS        ZDAYNO                                       234008
     C                   PARM                    BJDFIN                                       234008
     C                   PARM                    ErrorFlag                                    234008
                                                                                              234008
     C                   EVAL      K_SESN = DDPSSN                                            234008
     C                   EVAL      K_PTYP = 'PR'                                              234008
     C                   EVAL      K_PDAT = ZDAYNO                                            234008
                                                                                              234008
     C     KEYSC         SETLL     SNDEVDO                                                    234008
     C     KEYSCP        READE     SNDEVDO                                33                  234008
                                                                                              234008
     C                   IF        *IN33 = *OFF AND RECI = 'D'                                234008
     C****                         AND PROT = '7'                                             234008
     C                   Z-ADD     SNFP          JPEXI                                        234008
     C                   ELSE                                                                 234008
     C                   EVAL      JPEXI = 0                                                  233698
     C                   ENDIF                                                                234008
     C                   ENDIF
 
      ** Default the fiscal price for bonds
 
     C                   IF        WTYPE = 'B'
 
      ** If the Issue Price or Issue Date is blank, or if the Issue Price
      ** is equal to or greater than par, default the Fiscal Price
      ** to the Market Price.
 
     C                   IF        WISSP = *ZERO OR
     C                             WISSD = *ZERO OR
     C                             WISSP >= 100
 
     C**********         EVAL      JPEXI = JPPRC                                              233698
     C                   EVAL      JPEXI = 100                                                233698
 
      ** Else, calculate the fiscal price default for bonds using a staight-line
      ** amortisation.
 
     C                   ELSE
 
      ** Convert the Price Value Date to midas day number
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    DDPVDT
     C                   PARM      *ZEROS        ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
 
      ** Assign the values for the parameter
 
     C                   Z-ADD     WISSD         ZINDAT
     C                   Z-ADD     ZDAYNO        ZIBDAT
     C                   Z-ADD     WMATY         ZIFDAT
     C                   Z-ADD     WISSP         ZINRAT
     C                   Z-ADD     100           ZIFRAT
 
      ** To default the fiscal price for bonds, calculate using ZAINTPL2
 
     C*****BJCNCD        IFNE      'CH'                                                234440 234440
      ** Calculate the fiscal price based on a Straight Line.                                 236137
     C     EWTXCB        IFEQ      'B'                                                        236137
     C                   CALLB     'ZAINTPL2'
     C                   PARM                    ZINDAT
     C                   PARM                    ZIBDAT
     C                   PARM                    ZIFDAT
     C                   PARM                    ZINRAT
     C                   PARM                    ZIFRAT
     C                   PARM                    ZIBRAT
                                                                                              236137
      ** Use Actuarial interpolation.                                                         236137
     C                   ELSE                                                                 234440
     C                   CALL      'ZAACTUAR'                                                 234440
     C                   PARM      *BLANK        WRTCD            10                          234440
     C                   PARM                    WISSD                                        234440
     C                   PARM                    WISSP                                        234440
     C                   PARM                    WMATY                                        234440
     C                   PARM                    ZIFRAT                                       234440
     C                   PARM                    DYBS                                         234440
     C                   PARM                    DVBS                                         234440
     C                   PARM                    CDDS             48                          234440
     C                   PARM                    CRDS             12                          234440
     C                   PARM                    LCPN                                       BUG11164
     C                   PARM                    ZDAYNO                                       234440
     C                   PARM                    ZIBRAT                                       234440
     C                   ENDIF                                                                234440
 
      ** Move default fiscal price
 
     C                   Z-ADD     ZIBRAT        JPEXI
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
                                                                                              233698
     C                   MOVE      *BLANKS       ZFIELD                                       233698
     C                   MOVE      JPEXI         ZFIELD                                       233698
     C                   Z-ADD     8             ZADEC                                        233698
                                                                                              233698
     C                   CALLB     'ZEDIT'                                                    233698
     C                   PARM                    ZFIELD           16                          233698
     C                   PARM                    ZADEC             1 0                        233698
     C                   MOVE      ZFIELD        DDPEXI                                       233698
 
     C     EPEINTV       ENDSR
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
      ** ------
 
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Price Excluding Interest
     C                   PARM                    DDPEXI
 
      ** Price Type
     C                   PARM                    DDPPRT
 
      ** Security Shortname
     C                   PARM                    DDPSSN
 
      ** Price
     C                   PARM                    DDPPRC
 
      ** Price Value Date
     C                   PARM                    DDPVDT
 
      ** OUTPUTS
      ** -------
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXar
     C                   PARM                    MsgIDXar
     C                   PARM                    MsgDtaXar
 
      ** Price Excluding Interest OK Flag
     C                   PARM                    DDPEXIOK
 
      ** Fiscal Price
     C                   PARM                    JPEXI
 
      ** Access Bank details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     PRtcd         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     POptn         DBKEY
     C                   EXSR      *PSSR
     C                   END
                                                                                              236137
      ** Accesses to Country of Tax Codes with Country Code of Bank                           236137
      ** and blank Country of Residence.                                                      236137
                                                                                              236137
     C                   CALL      'AOCTTXR0'                                                 236137
     C                   PARM      *BLANKS       PRtcd                                        236137
     C                   PARM      '*KEY   '     POptn                                        236137
     C                   PARM      BJCNCD        PCtrt                                        236137
     C                   PARM      *BLANKS       PCtrr                                        236137
     C     SDCTTX        PARM      SDCTTX        DSFDY                                        236137
                                                                                              236137
      ** Database Error if no record found.                                                   236137
                                                                                              236137
     C     PRtcd         IFNE      *BLANKS                                                    236137
     C                   EVAL      DBFILE = 'SDCTTXPD'                                        236137
     C                   MOVEL     '004'         DBASE                                        236137
     C                   MOVEL     PCtrt         DBKEY                                        236137
     C                   EXSR      *PSSR                                                      236137
                                                                                              236137
     C                   END                                                                  236137
                                                                                              234008
     C     KEYSC         KLIST                                                                234008
     C                   KFLD                    K_SESN                                       234008
     C                   KFLD                    K_PTYP                                       234008
     C                   KFLD                    K_PDAT                                       234008
                                                                                              234008
     C     KEYSCP        KLIST                                                                234008
     C                   KFLD                    K_SESN                                       234008
     C                   KFLD                    K_PTYP                                       234008
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
