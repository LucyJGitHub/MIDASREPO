     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT RFT header convert')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM1011CT - Request for Transfer Conversion:                 *
      *              Database file to Screen Header Format            *
      *                                                               *
      *  Function:  This module converts depending the kind of input  *
      *     - a RFT header screen format                              *
      *     - a RFT header file format                                *
      *     - a MT101 sequence A format                               *
      *  if the convertion type is 'FH' (File header)                 *
      *     - to RFT header file format                               *
      *  if the convertion type is 'SH' (Screen header)               *
      *     - to RFT header screen format                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. AR928996A          Date 03May12               *
      *  Prev Amend No. AR928996           Date 27Mar12               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24998           Date 17Jul09               *
      *                 BUG25046           Date 20Jul09               *
      *                 BUG24802           Date 08Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG10602           Date 16Feb06               *
      *                 221761             Date 01Apr04               *
      *                 221538             Date 01Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 30May00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178384             Date 28apr00               *
      *                 178181             Date 27Apr00               *
      *                 CFT006  *Create    Date 30Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR928996A- Data truncation error. Amended PDATA and PDAT2    *
      *             data structure field to have the correct length.  *
      *             (Child: AR928997A)                                *
      *  AR928996 - Data lost due to rate field :36: being truncated. *
      *             (Child: AR928997)                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  BUG25046 - Sender not mapped for MT101 STP                   *
      *  BUG24802 - Sending institution in STP is missing             *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  221761 - Incorrect routing of multiple MT101s.               *
      *  221538 - Expansion of field details.                         *
      *  CFT009 - Addition of fields for FT fees and charges          *
      *           Recompile                                           *
      *  185107 - Mapping of details from swift message               *
      *  178384 - GEMS error, date is displayed in Midas day number   *
      *           convert it to DD/MM/YY for display purposes         *
      *  178181 - Sender's mapping incorrect for MT101's              *
      *  CFT006 - Funds Transfer addition of MT101 and MT102 messages *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

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
     D/COPY MECPYSRC,ME1100_ILE

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     D NBTYPE          C                   CONST(10)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      * RFT Header details in File format
     D DRftHdr       E DS                  EXTNAME(FT101HPD)

      * RFT Header details in Screen format
     D RftScnFmt     E DS                  EXTNAME(FT101HSPD)
     D PBRCH         E                     EXTFLD(PBRCA)

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D*
     D P8FT            DS           128                                                       221538
      *                                                                                       221538
      ** Currency                                                                             221538
     D  W8CCY                  1      3                                                       221538
      *                                                                                       221538
      ** Settlement Type                                                                      221538
     D  W8STMT                 4      5                                                       221538
      *                                                                                       221538
      ** Mandatory Text - convert BIC identifiers                                             221538
     D  W8MTXT                 6      6                                                       221538
      *                                                                                       221538
      ** Message Tag                                                                          221538
     D  W8MTAG                 7     11                                                       221538
      *                                                                                       221538
      ** Construct of data in field                                                           221538
     D  W8TYPE                12     12                                                       221538
      *                                                                                       221538
      ** Number of Lines available                                                            221538
     D  W8NLIN                13     14  0                                                    221538
      *                                                                                       221538
      ** Network and Message Type                                                             221538
     D  W8NWRK                15     20                                                       221538
     D  W8MTPY                21     23                                                       221538
      *                                                                                       221538
      ** Calling Program                                                                      221538
     D  W8CPGM                24     33                                                       221538
      *                                                                                       221538
      ** Action *PRINT/*ENQ/*MSG GEN                                                          221538
     D  W8ACT                 34     41                                                       221538
      *                                                                                       221538
      ** Critical Reporting - Database error if 'Y'.                                          221538
      ** If no BIC directory and BIC entered, no error.                                       221538
     D  W8CRIT                42     42                                                       221538
      *                                                                                       221538
      ** Force Midas Address - where possible                                                 221538
     D  W8MADD                43     43                                                       221538
      *                                                                                       221538
      ** If Retail, get first address from account                                            221538
     D  W8RTAD                44     44                                                       221538
      *                                                                                       221538
      ** Alternative Address                                                                  221538
     D  W8ALTN                45     45                                                       221538
      *                                                                                       221538
      ** Address Type                                                                         221538
     D  W8ADTP                46     46                                                       221538
      *                                                                                       221538
      ** DS for Redefining Address Fields                                                     221538
     D                 DS                                                                     221538
     D  WADDRSS                1    175                                                       221538
     D  WADCHK1                1     35                                                       221538
     D  WADCHK2               36     70                                                       221538
     D  WADCHK3               71    105                                                       221538
     D  WADCHK4              106    140                                                       221538
     D  WADCHK5              141    175                                                       221538
      *                                                                                       221538
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D AplyType        S              1    Dim(NBTYPE)

      ** Parameters for ZALIGN
     D zalignok        S              1
     D zfield          S             16
     D zadec           S              1  0
     D zadig           S              2  0

      ** Parameters for ZDATE1
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D DatFmt          S              1A
     D ErrorFlag       S              1A

      ** Parameters for ME1330
     D Prefix          S             20A
     D SpecialC        S            256A
     D AplyValue       S            256A
     D RetCode         S                   Like(RetCodeIn)
     D TypeValue       S              1A

      ** Message reference                                                      185107
     D MgmsgR          S                   LIKE(PhmsgR)                         185107
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C**************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C                   If        CnvTyp = 'SH'
     C                   Eval      RftScnFmt = *Blanks
     C                   Else
     C                   Clear                   DRftHdr
     C                   Endif
      *
      ** Set Output Screen Fields
      *
     C                   If        CnvTyp = 'SH'
     C                   If        PDATA = *BLANK
     C                   Exsr      SETSCN
     C                   Else
     C                   Exsr      FLEMSG
     C                   Exsr      SETSCN
     C                   Endif
     C                   Else
      *
      ** Set Output File Fields
      *
     C                   If        PDATA = *BLANK
     C                   Exsr      SETFLE
     C                   Else
     C                   Exsr      FLEMSG
     C                   Endif
     C                   Endif

      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT                                                                                  221538
      *****************************************************************                       221538
      *                                                               *                       221538
      *  SREXPGM - Call expansion program FT0315                      *                       221538
      *                                                               *                       221538
      *****************************************************************                       221538
      *                                                                                       221538
     C     SREXPGM       BEGSR                                                                221538
      *                                                                                       221538
      ** Call expansion program.                                                              221538
      *                                                                                       221538
     C                   CALL      'FT0315'                             9090                  221538
     C                   PARM      *BLANKS       P8RTN             7                          221538
     C                   PARM                    P8FT                                         221538
     C                   PARM                    P8LINS          256                          221538
     C                   PARM                    P8RPT           256                          221538
     C                   PARM                    P8MSG           256                          221538
     C                   PARM                    P8SCR           256                          221538
      *                                                                                       221538
      ** Check if database error occurred.                                                    221538
      *                                                                                       221538
     C     *IN90         IFEQ      '1'                                                        221538
     C     P8RTN         ORNE      *BLANKS                                                    221538
     C                   MOVEL     '*CALL'       DBKEY                                        221538
     C                   MOVEL     'FT0315  '    DBFILE                                       221538
     C                   Z-ADD     5             DBASE                                        221538
     C                   EXSR      *PSSR                                                      221538
     C                   ENDIF                                                                221538
      *                                                                                       221538
     C                   ENDSR                                                                221538
      *                                                                                       221538
      *****************************************************************                       221538
      /EJECT
      *****************************************************************
      ** FLEMSG - Set Output File Fields with message datas
      *****************************************************************
     C     FLEMSG        Begsr
      *
      * Map data of MT101
      *
      * Ordering customer
      *
     C                   If        PH50 <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     PH50          DSTRAN
     C                   If        TRCODE = *Blanks
     C                   Eval      HOCUS1 = TMLIN1
     C                   Eval      HOCUS2 = TMLIN2
     C                   Eval      HOCUS3 = TMLIN3
     C                   Eval      HOCUS4 = TMLIN4
     C                   Eval      HOCUS5 = TMLIN5
     C                   Else
     C                   Eval      AplyType(1) = 'F'
     C                   Eval      AplyType(2) = 'R'
     C                   Eval      AplyType(3) = 'G'
     C                   Exsr      APLYTRN
     C                   Eval      HOCUS1 = AplyValue
     C                   Endif
     C                   Endif
      *
      * Instructing party
      *
     C                   If        PH50L <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     PH50L         DSTRAN
     C                   If        TRCODE = *Blanks
     C                   Eval      HINPTY = TMLIN1
     C                   Else
     C                   Eval      AplyType(1) = 'C'
     C                   Exsr      APLYTRN
     C                   Eval      HINPTY = AplyValue
     C                   Endif
     C                   Endif
      *
      * Account Servicing Institution
      *
     C                   If        PH52 <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     PH52          DSTRAN
     C                   If        TRCODE = *Blanks
     C                   Eval      HACSV1 = TMLIN1
     C                   Else
     C                   Eval      AplyType(1) = 'F'
     C                   Eval      AplyType(2) = 'R'
     C                   Eval      AplyType(3) = 'G'
     C                   Exsr      APLYTRN
     C                   Eval      HACSV1 = AplyValue
     C                   Endif
     C                   Endif
      *
      * Customer reference
      *
     C                   If        PH21R <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     PH21R         DSTRAN
     C                   Eval      CUSTRF = TMLIN1
     C                   Endif
      *
      * Sender's Reference
      *
     C                   If        PH20 <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     PH20          DSTRAN
     C                   Eval      SNDREF = TTREF
     C                   Endif
      *
      * Sending Institution
      *
     C*******************If        PSNDR <> *Blanks                             178181
     C                   If        PH51A <> *Blanks                             178181
     C                   Reset                   DSTRAN
     C                   Movel     PH51A         DSTRAN                         178181
     C                   If        TRCODE = *Blanks                             178181
     C                   Eval      SINST = TMLIN1                               178181
     C                   Else                                                   178181
     C                   Eval      AplyType(1) = 'F'                            178181
     C                   Eval      AplyType(2) = 'R'                            178181
     C                   Eval      AplyType(3) = 'G'                            178181
     C                   Eval      AplyType(4) = 'C'                            178181
     C                   Exsr      APLYTRN                                      178181
     C                   Eval      SINST = AplyValue                            178181
     C                   Endif                                                  178181
     C*******************Eval      SINST = PSNDR                                178181
     C                   ELSE                                                               BUG24802
     C**********         IF        PYTP = 'RI'                                     BUG24802 BUG25046
     C                   EVAL      SINST = PSNDR                                            BUG24802
     C**********         Endif                                                     BUG24802 BUG25046
     C                   Endif
      *
      * Execution Date
      *
     C                   If        PH30  <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     PH30          DSTRAN
      ** Swift Convention date format is YYMMDD
      ** We need to reformat it into  DDMMYY before converting
      ** it into Midas day number (parm accepted are only D or M)
     C                   EVAL      %SUBST(PEXDATE:1:2) = %SUBST(TVDCA:5:2)
     C                   EVAL      %SUBST(PEXDATE:3:2) = %SUBST(TVDCA:3:2)
     C                   EVAL      %SUBST(PEXDATE:5:2) = %SUBST(TVDCA:1:2)
     C                   If        PEXDATE <> *Blanks
      *
     C                   CallB     'ZDATE1'
     C                   Parm      PEXDATE       DateIn
     C                   Parm      *Zeros        DaynoOut
     C                   Parm      'D'           DatFmt
     C                   Parm      *Blank        ErrorFlag
      *
     C                   Z-add     DaynoOut      EXDATE
     C                   Endif
     C                   Endif
      *
      * Authorisation
      *
     C                   If        PH25 <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     PH25          DSTRAN
     C                   Eval      AUTHTX = TMLIN1
     C                   Endif

      ** Map Swift ID
     C                   Eval      STID = PSNDR
      *                                                                         185107
      ** Message Reference                                                      185107
      *                                                                         185107
     C                   Z-ADD     MGMSGR        RHMSGR                         185107


     C                   Endsr
      *****************************************************************
      ** SETSCN - Set Output Screen Fields
      *****************************************************************
     C     SETSCN        Begsr
      *
      * Request for Transfer ID
      *
     C                   MOVE      RFTID         PRFTID
      *
      * Senders Reference
      *
     C                   Move      SNDREF        PSNDREF
      *                                                                                       221761
      ** Sender's Reference Routing Sequence                                                  221761
      *                                                                                       221761
     C                   Move      RSEQNO        PRSEQNO                                      221761
      *
      * Customer Reference
      *
     C                   Move      CUSTRF        PCUSTRF
      *
      * RFT Type
      *
     C                   Move      PYTP          PPTYP
      *
      * Transfer Sub Type
      *
     C                   Move      PYST          PPYST
      *
      * Booking Branch
      *
     C                   Move      BRCA          PBRCH
      *
      * Originating Branch
      *
     C                   Move      ORBR          PORBR
      *
      * Book Code
      *
     C                   Move      BOKC          PBOKC
      *
      * Profit Centre
      *
     C                   MOVE      PRFC          PPRFC
      *
      * Swift Priority
      *
     C                   Move      SWPRIO        PSWPRIO
      *
      * Instructing Party
      *
     C                   Move      HINPTY        PHINPTY
      *
      * Ordering Customers
      *
     C                   Move      HOCUS1        PHOCUS1
     C                   Move      HOCUS2        PHOCUS2
     C                   Move      HOCUS3        PHOCUS3
     C                   Move      HOCUS4        PHOCUS4
     C                   Move      HOCUS5        PHOCUS5
      *                                                                                       221538
     C     Actn          IFEQ      'E'                                                        221538
      *                                                                                       221538
     C                   CLEAR                   P8FT                                         221538
     C                   MOVEL     *BLANKS       W8STMT                                       221538
     C                   MOVEL     PSPROCPGM     W8CPGM                                       221538
     C                   MOVEL     '*ENQ  '      W8ACT                                        221538
     C                   Z-ADD     5             W8NLIN                                       221538
      *                                                                                       221538
     C                   MOVEL     CUSTTP        W8TYPE                                       221538
     C                   MOVEL     *BLANKS       P8LINS                                       221538
     C                   MOVEL     *BLANKS       WADDRSS                                      221538
     C                   MOVEL     *BLANKS       WLDGER                                       221538
     C     CUSTTP        IFEQ      'G'                                                        221538
     C                   MOVEL     HOCUS1        WLDGER           18                          221538
     C                   MOVE      WLDGER        WACCNT           15                          221538
     C                   MOVEL     WLDGER        WBRCA             3                          221538
     C     WACCNT        CAT       WBRCA         WADCHK1                                      221538
     C                   ELSE                                                                 221538
     C                   MOVEL     HOCUS1        WADCHK1                                      221538
     C                   ENDIF                                                                221538
     C                   MOVEL     HOCUS2        WADCHK2                                      221538
     C                   MOVEL     HOCUS3        WADCHK3                                      221538
     C                   MOVEL     HOCUS4        WADCHK4                                      221538
     C                   MOVEL     HOCUS5        WADCHK5                                      221538
     C                   MOVEL     WADDRSS       P8LINS                                       221538
      *                                                                                       221538
     C                   EXSR      SREXPGM                                                    221538
      *                                                                                       221538
     C     35            SUBST     P8SCR:1       PHOCUS1                                      221538
     C     CUSTTP        IFEQ      'G'                                                        221538
     C                   MOVEL     WLDGER        PHOCUS1                                      221538
     C                   ENDIF                                                                221538
     C     35            SUBST     P8SCR:36      PHOCUS2                                      221538
     C     35            SUBST     P8SCR:71      PHOCUS3                                      221538
     C     35            SUBST     P8SCR:106     PHOCUS4                                      221538
     C     35            SUBST     P8SCR:141     PHOCUS5                                      221538
      *                                                                                       221538
     C                   ENDIF                                                                221538
      *
      * Destination
      *
     C                   Move      RFTDST        PRFTDST
      *
      * Account Servicing Institution
      *
     C                   Move      HACSV1        PHACSV1
     C                   Movel     HACSV2        PHACSV2
      *
      * Set up Debit Value Date
      *
     C                   If        DBTVDT <> *Zeros
     C                   Z-add     DBTVDT        ZDAYNO
     C                   Exsr      SRFTDT
     C                   Move      ZDATE         PDBTVDT
     C                   Else
     C                   Movel     *Blanks       PDBTVDT
     C                   Endif
      *
      * Set up Request Execution Date
      *
     C                   If        EXDATE <> *Zeros
     C                   Z-add     EXDATE        ZDAYNO
     C                   Exsr      SRFTDT
     C                   Move      ZDATE         PEXDATE
     C                   Else
     C                   Movel     *Blanks       PEXDATE
     C                   Endif
      *
      * Handling Ccy and Handling Charge
      *
     C                   If        HANDCY <> *Blanks
     C                   Move      HANDCY        PHANDCY
      *
     C                   Callb     'AOCURRR0'
     C                   Parm      *BLANK        @RTCD             7
     C                   Parm      '*KEY   '     @OPTN             7
     C                   Parm      HANDCY        @AJCD             3
     C     SDCURR        Parm      SDCURR        DSSDY
      *
      * Format amount
      *
     C                   Z-add     HANDCG        @@AMTW
     C                   Z-add     A6NBDP        @@QECN
     C                   Exsr      SRFTAM
     C                   Move      @@AMTD        PHANDCG
     C                   Else
     C                   Movel     *Blanks       PHANDCG
     C                   Endif
      *
      * Charges to the debit of
      *
     C                   Move      HANDAC        PHANDAC
      *
      * Sending Institution
      *
     C                   Move      SINST         PSINST
      *
      * Authorisation
      *
     C                   Move      AUTHTX        PAUTHTX
      *
      * Types
      *
     C                   Move      ASITTP        PASITTP
     C                   Move      CUSTTP        PCUSTTP
     C                   Move      STID          PSTID
      *
      * User Data
     C                   MOVEL     INUSER        PINUSER
     C***********        MOVEL     INDATE        PINDATE                        178384
     C                   If        Indate <> *Zeros                             178384
     C                   Z-add     Indate        ZDAYNO                         178384
     C                   Exsr      SRFTDT                                       178384
     C                   Move      ZDATE         PIndate                        178384
     C                   Else                                                   178384
     C                   Movel     *Blanks       PIndate                        178384
     C                   Endif                                                  178384
      *                                                                         178384
     C                   MOVEL     INTIME        PINTIME
     C                   MOVEL     UPDUSR        PUPDUSR
      *                                                                         178384
     C*******            MOVEL     UPDDTE        PUPDDTE                        178384
     C                   If        upddte <> *Zeros                             178384
     C                   Z-add     upddte        ZDAYNO                         178384
     C                   Exsr      SRFTDT                                       178384
     C                   Move      ZDATE         Pupddte                        178384
     C                   Else                                                   178384
     C                   Movel     *Blanks       Pupddte                        178384
     C                   Endif                                                  178384
      *                                                                         178384
     C                   MOVEL     UPDTIM        PUPDTIM
     C                   MOVEL     AUP1          PAUP1
     C                   MOVEL     AUP2          PAUP2
     C                   MOVEL     RDUAL         PRDUAL
     C                   MOVEL     AUIN          PAUIN
     C                   MOVEL     BAUTH         PBAUTH
     C                   MOVEL     BATUSR        PBATUSR
      *                                                                         185107
      ** Message Reference                                                      185107
      *                                                                         185107
     C                   Z-ADD     RHMSGR        PRHMSGR                        185107

      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLE - Set Output File Fields
      *****************************************************************
     C     SETFLE        Begsr
      *
      * Request for Transfer ID
      *
     C                   MOVE      PRFTID        RFTID
      *
      * Senders Reference
      *
     C                   Move      PSNDREF       SNDREF
      *                                                                                       221761
      ** Sender's Reference Routing Sequence                                                  221761
      *                                                                                       221761
     C                   Move      PRSEQNO       RSEQNO                                       221761
      *
      * Customer Reference
      *
     C                   Move      PCUSTRF       CUSTRF
      *
      * RFT Type
      *
     C                   Move      PPTYP         PYTP
      *
      * Transfer Sub Type
      *
     C                   Move      PPYST         PYST
      *
      * Booking Branch
      *
     C                   Move      PBRCH         BRCA
      *
      * Originating Branch
      *
     C                   Move      PORBR         ORBR
      *
      * Book Code
      *
     C                   Move      PBOKC         BOKC
      *
      * Profit Centre
      *
     C                   MOVE      PPRFC         PRFC
      *
      * Swift Priority
      *
     C                   Move      PSWPRIO       SWPRIO
      *
      * Instructing Party
      *
     C                   Move      PHINPTY       HINPTY
      *
      * Ordering Customers
      *
     C                   Move      PHOCUS1       HOCUS1
     C                   Move      PHOCUS2       HOCUS2
     C                   Move      PHOCUS3       HOCUS3
     C                   Move      PHOCUS4       HOCUS4
     C                   Move      PHOCUS5       HOCUS5
      *
      * Destination
      *
     C                   Move      PRFTDST       RFTDST
      *
      * Account Servicing Institution
      *
     C                   Move      PHACSV1       HACSV1
     C                   Movel     PHACSV2       HACSV2
      *
      * Set up Debit Value Date
      *
     C                   If        PDBTVDT <> *Blanks
      *
     C                   CallB     'ZDATE1'
     C                   Parm      PDBTVDT       DateIn
     C                   Parm      *Zeros        DaynoOut
     C                   Parm      BJDFIN        DatFmt
     C                   Parm      *Blank        ErrorFlag
      *
     C                   Z-add     DaynoOut      DBTVDT
     C                   Endif
      *
      * Set up Request Execution Date
      *
     C                   If        PEXDATE <> *Blanks
      *
     C                   CallB     'ZDATE1'
     C                   Parm      PEXDATE       DateIn
     C                   Parm      *Zeros        DaynoOut
     C                   Parm      BJDFIN        DatFmt
     C                   Parm      *Blank        ErrorFlag
      *
     C                   Z-add     DaynoOut      EXDATE
     C                   Endif
      *
      * Handling Ccy and Handling Charge
      *
     C                   If        PHANDCY <> *Blanks
     C                   Move      PHANDCY       HANDCY
      *
     C                   Callb     'AOCURRR0'
     C                   Parm      *BLANK        @RTCD             7
     C                   Parm      '*KEY   '     @OPTN             7
     C                   Parm      PHANDCY       @AJCD             3
     C     SDCURR        Parm      SDCURR        DSSDY
      *
      * Format amount
      *
     C                   Move      *Blanks       zfield
     C                   Move      PHANDCG       zfield
     C                   Eval      zadec = A6NBDP
     C                   Eval      zadig = 13 - A6NBDP
     C                   Exsr      SRFAFL
      *
     C                   Move      zfield        HANDCG
     C                   Endif
      *
      * Charges to the debit of
      *
     C                   Move      PHANDAC       HANDAC
      *
      * Sending Institution
      *
     C                   Move      PSINST        SINST
      *
      * Authorisation
      *
     C                   Move      PAUTHTX       AUTHTX
      *
      * Types
      *
     C                   Move      PASITTP       ASITTP
     C                   Move      PCUSTTP       CUSTTP
     C                   Move      PSTID         STID

      *                                                                         178384
      * User Data                                                               178384
     C                   MOVEL     PINUSER       INUSER                         178384
      *                                                                         178384
     C                   If        PIndate <> *Blanks                           178384
     C                   CallB     'ZDATE1'                                     178384
     C                   Parm      PIndate       DateIn                         178384
     C                   Parm      *Zeros        DaynoOut                       178384
     C                   Parm      BJDFIN        DatFmt                         178384
     C                   Parm      *Blank        ErrorFlag                      178384
      *                                                                         178384
     C                   Z-add     DaynoOut      Indate                         178384
     C                   Endif                                                  178384
      *                                                                         178384
     C                   MOVEL     PINTIME       INTIME                         178384
     C                   MOVEL     PUPDUSR       UPDUSR                         178384
      *                                                                         178384
     C                   If        PUpddte <> *Blanks                           178384
     C                   CallB     'ZDATE1'                                     178384
     C                   Parm      Pupddte       DateIn                         178384
     C                   Parm      *Zeros        DaynoOut                       178384
     C                   Parm      BJDFIN        DatFmt                         178384
     C                   Parm      *Blank        ErrorFlag                      178384
      *                                                                         178384
     C                   Z-add     DaynoOut      Upddte                         178384
     C                   Endif                                                  178384
      *                                                                         178384
     C                   MOVEL     PUPDTIM       UPDTIM                         178384
     C                   MOVEL     PAUP1         AUP1                           178384
     C                   MOVEL     PAUP2         AUP2                           178384
     C                   MOVEL     PRDUAL        RDUAL                          178384
     C                   MOVEL     PAUIN         AUIN                           178384
     C                   MOVEL     PBAUTH        BAUTH                          178384
     C                   MOVEL     PBATUSR       BATUSR                         178384
      *                                                                         185107
      ** Message Reference                                                      185107
      *                                                                         185107
     C                   Z-ADD     PRHMSGR       RHMSGR                         185107
                                                                                178384
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      ** APLYTRN - Apply translation
      *****************************************************************
     C     APLYTRN       Begsr

     C                   Callb     'ME1330'
     C                   Parm                    TRCODE
     C                   Parm                    Prefix
     C                   Parm                    AplyType
     C                   Parm                    SpecialC
     C                   Parm                    AplyValue
     C                   Parm                    RetCode
     C                   Parm                    TypeValue

     C                   Eval      Prefix = *Blank
     C                   Eval      AplyType = *Blank

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFTDT - Format Date for Display                              *
      *****************************************************************
     C     SRFTDT        Begsr
      *
     C                   Callb     'ZDATE2'
     C                   Parm                    ZDAYNO            5 0
     C                   Parm      BJDFIN        ZDATFM            1
     C                   Parm      *Zeros        ZDATE             6 0
     C                   Parm      *Blanks       ZADATE            7
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFTAM - Format Amount For Display                            *
      *****************************************************************
     C     SRFTAM        Begsr
      *
     C                   Callb     'ZA0920'
     C                   Parm      *Blank        @@RETC           10
     C                   Parm                    @@AMTW           13 0
     C                   Parm                    @@QECN            1 0
     C                   Parm      '.'           BNDCSP            1
     C                   Parm      *Blank        @@AMTD           14
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFAFL - Format Amount for File                               *
      *****************************************************************
     C     SRFAFL        Begsr
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    zalignok
     C                   PARM                    zfield
     C                   PARM                    zadec
     C                   PARM                    zadig
      *
      * Database Error
      *
     C                   If        zalignok = 'N'
     C                   Movel     'ZALIGN  '    DBFILE
     C                   Z-add     3             DBASE
     C                   Movel     ZFIELD        DBKEY
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Exsr      *PSSR
     C                   Endif
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing                                   *
      *****************************************************************
     C     *INZSR        Begsr
      *
      **  Program Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   Parm                    RetCodeIn
      *                                                                                       221538
      ** Action Code                                                                          221538
      *                                                                                       221538
     C                   Parm                    Actn              1                          221538
      *
      * Type of Conversion
      *
     C                   Parm                    CnvTyp            2
      *
      * RFT Header Details in file format
      *
     C                   Parm                    DRftHdr
      *
      * MT101 details in message format
      *
     C                   Parm                    PDATA
      *                                                                                       CSW209
      * MT101 details in message format extension                                             CSW209
      *                                                                                       CSW209
     C                   Parm                    PDAT2                                        CSW209
      *                                                                         185107
      ** Message reference                                                      185107
      *                                                                         185107
     C                   PARM                    MGMSGR                         185107
      *
      * Output parameters
      *
      * RFT details in screen format
      *
     C                   Parm                    RftScnFmt
      *
      * Initialize program name
      *
     C                   Movel     'FTM1011CT'   DBPGM
      *
      * Access Bank Details
      *
     C                   Call      'AOBANKR0'
     C                   Parm      *BLANKS       @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C     SDBANK        Parm      SDBANK        DSFDY
      *
      * Database Error
      *
     C                   If        @RTCD <> *Blanks
     C                   Movel     'SDBANKPD'    DBFILE
     C                   Movel     '001'         DBASE
     C                   Movel     @OPTN         DBKEY
     C                   Exsr      *PSSR
     C                   Endif
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
