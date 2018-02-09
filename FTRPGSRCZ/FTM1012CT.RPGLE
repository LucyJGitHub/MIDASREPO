     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT RFT credit convert')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM1012CT - Request for Transfer Conversion:                 *
      *              Database file to Screen Detail Format            *
      *                                                               *
      *  Function:  This module converts depending the kind of input  *
      *     - a RFT detail screen format                              *
      *     - a RFT detail file format                                *
      *     - a MT101 sequence B format                               *
      *  if the convertion type is 'FC' (File detail)                 *
      *     - to RFT detail file format                               *
      *  if the convertion type is 'SC' (Screen detail)               *
      *     - to RFT detail screen format                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG24998           Date 17Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG10602           Date 16Feb06               *
      *                 221538             Date 01Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 30May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178751             Date 09May00               *
      *                 178384             Date 28apr00               *
      *                 CFT006  *Create    Date 30Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  221538 - Expansion of field details.                         *
      *  CFT009 - Addition of fields for FT fees and charges          *
      *           Recompile                                           *
      *  178751 - Auto generation of references                       *
      *  178384 - GEMS error, date is displayed in Midas day number   *
      *           convert it to DD/MM/YY for display purposes         *
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D NBTYPE          C                   CONST(10)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
 
      * RFT Details in File Format
     D DRftDtl       E DS                  EXTNAME(FT101DPD)
 
      * RFT Header Details in Screen Format
     D RftScnFmt     E DS                  EXTNAME(FT101DSPD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
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
     D/COPY MECPYSRC,ME1100_ILE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D AplyType        S              1    Dim(NBTYPE)
 
      ** Position of ',' into an amount
     D Comma           S              2  0
 
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
     D****TRCODE       S
     D Prefix          S             20A
     D****AplyType     S
     D SpecialC        S            256A
     D AplyValue       S            256A
     D RetCode         S                   Like(RetCodeIn)
     D TypeValue       S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C**************************************************************
     C                   If        CnvTyp = 'SC'
     C                   Eval      RftScnFmt = *Blanks
     C                   Else
     C                   Clear                   DRftDtl
     C                   Endif
      *
      ** Set Output Screen Fields
      *
     C                   If        CnvTyp = 'SC'
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
     C                   Return
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
      ** SETSCN - Set Output Screen Fields
      *****************************************************************
     C     SETSCN        Begsr
      *
      * Request for Transfer ID
      *
     C                   Move      RFTID         PRFTHDR
      *                                                                         178751
      * Credit sequence number                                                  178751
      *                                                                         178751
     C                   Move      TSEQNO        PTSEQNO                        178751
      *
      * Transaction ID
      *
     C                   Move      TRNSID        PTRNSID
      *
      * Beneficiary
      *
     C                   Movel     TBNA35        PBNA35
     C                   Movel     TBNB35        PBNB35
     C                   Movel     TBNC35        PBNC35
     C                   Movel     TBND35        PBND35
     C                   Movel     TBNE35        PBNE35
      *                                                                                       221538
     C     Actn          IFEQ      'E'                                                        221538
      *                                                                                       221538
     C                   CLEAR                   P8FT                                         221538
     C                   MOVEL     *BLANKS       W8STMT                                       221538
     C                   MOVEL     PSPROCPGM     W8CPGM                                       221538
     C                   MOVEL     '*ENQ  '      W8ACT                                        221538
     C                   Z-ADD     5             W8NLIN                                       221538
      *                                                                                       221538
     C                   MOVEL     BENTTP        W8TYPE                                       221538
     C                   MOVEL     *BLANKS       P8LINS                                       221538
     C                   MOVEL     *BLANKS       WADDRSS                                      221538
     C                   MOVEL     *BLANKS       WLDGER                                       221538
     C     BENTTP        IFEQ      'G'                                                        221538
     C                   MOVEL     TBNA35        WLDGER           18                          221538
     C                   MOVE      WLDGER        WACCNT           15                          221538
     C                   MOVEL     WLDGER        WBRCA             3                          221538
     C     WACCNT        CAT       WBRCA         WADCHK1                                      221538
     C                   ELSE                                                                 221538
     C                   MOVEL     TBNA35        WADCHK1                                      221538
     C                   ENDIF                                                                221538
     C                   MOVEL     TBNB35        WADCHK2                                      221538
     C                   MOVEL     TBNC35        WADCHK3                                      221538
     C                   MOVEL     TBND35        WADCHK4                                      221538
     C                   MOVEL     TBNE35        WADCHK5                                      221538
     C                   MOVEL     WADDRSS       P8LINS                                       221538
      *                                                                                       221538
     C                   EXSR      SREXPGM                                                    221538
      *                                                                                       221538
     C     35            SUBST     P8SCR:1       PBNA35                                       221538
     C     BENTTP        IFEQ      'G'                                                        221538
     C                   MOVEL     WLDGER        PBNA35                                       221538
     C                   ENDIF                                                                221538
     C     35            SUBST     P8SCR:36      PBNB35                                       221538
     C     35            SUBST     P8SCR:71      PBNC35                                       221538
     C     35            SUBST     P8SCR:106     PBND35                                       221538
     C     35            SUBST     P8SCR:141     PBNE35                                       221538
      *                                                                                       221538
     C                   ENDIF                                                                221538
      *
      * Account with Institution
      *
     C                   Movel     TACA11        PACA11
     C                   Movel     TACA35        PACA35
     C                   Movel     TACB35        PACB35
     C                   Movel     TACC35        PACC35
     C                   Movel     TACD35        PACD35
     C                   Movel     TACE35        PACE35
      *                                                                                       221538
     C     Actn          IFEQ      'E'                                                        221538
      *                                                                                       221538
     C                   CLEAR                   P8FT                                         221538
     C                   MOVEL     *BLANKS       W8STMT                                       221538
     C                   MOVEL     PSPROCPGM     W8CPGM                                       221538
     C                   MOVEL     '*ENQ  '      W8ACT                                        221538
     C                   Z-ADD     5             W8NLIN                                       221538
      *                                                                                       221538
     C                   MOVEL     AWITTP        W8TYPE                                       221538
     C                   MOVEL     *BLANKS       P8LINS                                       221538
     C                   MOVEL     *BLANKS       WADDRSS                                      221538
     C                   MOVEL     *BLANKS       WLDGER                                       221538
     C     AWITTP        IFEQ      'G'                                                        221538
     C                   MOVEL     TACA35        WLDGER                                       221538
     C                   MOVE      WLDGER        WACCNT                                       221538
     C                   MOVEL     WLDGER        WBRCA                                        221538
     C     WACCNT        CAT       WBRCA         WADCHK1                                      221538
     C                   ELSE                                                                 221538
     C                   MOVEL     TACA35        WADCHK1                                      221538
     C                   ENDIF                                                                221538
     C                   MOVEL     TACB35        WADCHK2                                      221538
     C                   MOVEL     TACC35        WADCHK3                                      221538
     C                   MOVEL     TACD35        WADCHK4                                      221538
     C                   MOVEL     TACE35        WADCHK5                                      221538
     C                   MOVEL     WADDRSS       P8LINS                                       221538
     C     PACA11        IFNE      *BLANKS                                                    221538
     C     AWITTP        IFEQ      'C'                                                        221538
     C     AWITTP        OREQ      'S'                                                        221538
     C                   MOVEL     PACA11        P8LINS                                       221538
     C                   ENDIF                                                                221538
     C                   ENDIF                                                                221538
      *                                                                                       221538
     C                   EXSR      SREXPGM                                                    221538
      *                                                                                       221538
     C     PACA11        IFNE      *BLANKS                                                    221538
     C     AWITTP        ANDEQ     'S'                                                        221538
     C     35            SUBST     P8SCR:36      PACA35                                       221538
     C     35            SUBST     P8SCR:71      PACB35                                       221538
     C     35            SUBST     P8SCR:106     PACC35                                       221538
     C     35            SUBST     P8SCR:141     PACD35                                       221538
     C                   MOVE      *BLANKS       PACE35                                       221538
     C                   ELSE                                                                 221538
      *                                                                                       221538
     C     PACA11        IFNE      *BLANKS                                                    221538
     C     AWITTP        ANDEQ     'C'                                                        221538
     C     12            SUBST     P8SCR:24      PACA35                                       221538
     C                   ELSE                                                                 221538
     C     AWITTP        IFEQ      'G'                                                        221538
     C     35            SUBST     P8SCR:1       PACA35                                       221538
     C                   MOVEL     WLDGER        PACA35                                       221538
     C                   ELSE                                                                 221538
     C     35            SUBST     P8SCR:1       PACA35                                       221538
     C                   ENDIF                                                                221538
     C                   ENDIF                                                                221538
     C     35            SUBST     P8SCR:36      PACB35                                       221538
     C     35            SUBST     P8SCR:71      PACC35                                       221538
     C     35            SUBST     P8SCR:106     PACD35                                       221538
     C     35            SUBST     P8SCR:141     PACE35                                       221538
      *                                                                                       221538
     C                   ENDIF                                                                221538
     C                   ENDIF                                                                221538
      *
      * Intermediary
      *
     C                   Movel     TINSTA        PINSTA
     C                   Movel     TINST1        PINST1
     C                   Movel     TINST2        PINST2
     C                   Movel     TINST3        PINST3
     C                   Movel     TINST4        PINST4
     C                   Movel     TINST5        PINST5
      *                                                                                       221538
     C     Actn          IFEQ      'E'                                                        221538
      *                                                                                       221538
     C                   CLEAR                   P8FT                                         221538
     C                   MOVEL     *BLANKS       W8STMT                                       221538
     C                   MOVEL     PSPROCPGM     W8CPGM                                       221538
     C                   MOVEL     '*ENQ  '      W8ACT                                        221538
     C                   Z-ADD     5             W8NLIN                                       221538
      *                                                                                       221538
     C                   MOVEL     INTTTP        W8TYPE                                       221538
     C                   MOVEL     *BLANKS       P8LINS                                       221538
     C                   MOVEL     *BLANKS       WADDRSS                                      221538
     C     INTTTP        IFEQ      'G'                                                        221538
     C                   MOVEL     TINST1        WLDGER                                       221538
     C                   MOVE      WLDGER        WACCNT                                       221538
     C                   MOVEL     WLDGER        WBRCA                                        221538
     C     WACCNT        CAT       WBRCA         WADCHK1                                      221538
     C                   ELSE                                                                 221538
     C                   MOVEL     TINST1        WADCHK1                                      221538
     C                   ENDIF                                                                221538
     C                   MOVEL     TINST2        WADCHK2                                      221538
     C                   MOVEL     TINST3        WADCHK3                                      221538
     C                   MOVEL     TINST4        WADCHK4                                      221538
     C                   MOVEL     TINST5        WADCHK5                                      221538
     C                   MOVEL     WADDRSS       P8LINS                                       221538
      *                                                                                       221538
     C     TINSTA        IFNE      *BLANKS                                                    221538
     C     INTTTP        IFEQ      'C'                                                        221538
     C     INTTTP        OREQ      'S'                                                        221538
     C                   MOVEL     TINSTA        P8LINS                                       221538
     C                   ENDIF                                                                221538
     C                   ENDIF                                                                221538
      *                                                                                       221538
     C                   EXSR      SREXPGM                                                    221538
      *                                                                                       221538
     C     TINSTA        IFNE      *BLANKS                                                    221538
     C     INTTTP        ANDEQ     'S'                                                        221538
     C     35            SUBST     P8SCR:36      PINST1                                       221538
     C     35            SUBST     P8SCR:71      PINST2                                       221538
     C     35            SUBST     P8SCR:106     PINST3                                       221538
     C     35            SUBST     P8SCR:141     PINST4                                       221538
     C                   MOVE      *BLANKS       PINST5                                       221538
     C                   ELSE                                                                 221538
      *                                                                                       221538
     C     TINSTA        IFNE      *BLANKS                                                    221538
     C     INTTTP        ANDEQ     'C'                                                        221538
     C     12            SUBST     P8SCR:24      PINST1                                       221538
     C                   ELSE                                                                 221538
     C     INTTTP        IFEQ      'G'                                                        221538
     C     35            SUBST     P8SCR:1       PINST1                                       221538
     C                   MOVEL     WLDGER        PINST1                                       221538
     C                   ELSE                                                                 221538
     C     35            SUBST     P8SCR:1       PINST1                                       221538
     C                   ENDIF                                                                221538
     C                   ENDIF                                                                221538
     C     35            SUBST     P8SCR:36      PINST2                                       221538
     C     35            SUBST     P8SCR:71      PINST3                                       221538
     C     35            SUBST     P8SCR:106     PINST4                                       221538
     C     35            SUBST     P8SCR:141     PINST5                                       221538
      *                                                                                       221538
     C                   ENDIF                                                                221538
     C                   ENDIF                                                                221538
      *
      * Instructing Party
      *
     C                   Movel     TINPTY        PINPTY
      *
      * Ordering Customer
      *
     C                   Movel     TOCUS1        POCUS1
     C                   Movel     TOCUS2        POCUS2
     C                   Movel     TOCUS3        POCUS3
     C                   Movel     TOCUS4        POCUS4
     C                   Movel     TOCUS5        POCUS5
      *                                                                                       221538
     C     Actn          IFEQ      'E'                                                        221538
      *                                                                                       221538
     C                   CLEAR                   P8FT                                         221538
     C                   MOVEL     *BLANKS       W8STMT                                       221538
     C                   MOVEL     PSPROCPGM     W8CPGM                                       221538
     C                   MOVEL     '*ENQ  '      W8ACT                                        221538
     C                   Z-ADD     5             W8NLIN                                       221538
      *                                                                                       221538
     C                   MOVEL     DCUSTP        W8TYPE                                       221538
     C                   MOVEL     *BLANKS       P8LINS                                       221538
     C                   MOVEL     *BLANKS       WADDRSS                                      221538
     C     DCUSTP        IFEQ      'G'                                                        221538
     C                   MOVEL     TOCUS1        WLDGER                                       221538
     C                   MOVE      WLDGER        WACCNT                                       221538
     C                   MOVEL     WLDGER        WBRCA                                        221538
     C     WACCNT        CAT       WBRCA         WADCHK1                                      221538
     C                   ELSE                                                                 221538
     C                   MOVEL     TOCUS1        WADCHK1                                      221538
     C                   ENDIF                                                                221538
     C                   MOVEL     TOCUS2        WADCHK2                                      221538
     C                   MOVEL     TOCUS3        WADCHK3                                      221538
     C                   MOVEL     TOCUS4        WADCHK4                                      221538
     C                   MOVEL     TOCUS5        WADCHK5                                      221538
     C                   MOVEL     WADDRSS       P8LINS                                       221538
      *                                                                                       221538
     C     TOCUS2        IFNE      *BLANKS                                                    221538
     C     TOCUS1        ANDEQ     *BLANKS                                                    221538
     C     DCUSTP        ANDEQ     'C'                                                        221538
     C                   MOVEL     TOCUS2        P8LINS                                       221538
     C                   ENDIF                                                                221538
      *                                                                                       221538
     C                   EXSR      SREXPGM                                                    221538
      *                                                                                       221538
     C     TOCUS2        IFNE      *BLANKS                                                    221538
     C     TOCUS1        ANDEQ     *BLANKS                                                    221538
     C     DCUSTP        ANDEQ     'C'                                                        221538
     C     35            SUBST     P8SCR:1       POCUS2                                       221538
     C     35            SUBST     P8SCR:36      POCUS3                                       221538
     C     35            SUBST     P8SCR:71      POCUS4                                       221538
     C     35            SUBST     P8SCR:106     POCUS5                                       221538
     C                   ELSE                                                                 221538
     C     35            SUBST     P8SCR:1       POCUS1                                       221538
     C     DCUSTP        IFEQ      'G'                                                        221538
     C                   MOVEL     WLDGER        POCUS1                                       221538
     C                   ENDIF                                                                221538
     C     35            SUBST     P8SCR:36      POCUS2                                       221538
     C     35            SUBST     P8SCR:71      POCUS3                                       221538
     C     35            SUBST     P8SCR:106     POCUS4                                       221538
     C     35            SUBST     P8SCR:141     POCUS5                                       221538
      *                                                                                       221538
     C                   ENDIF                                                                221538
     C                   ENDIF                                                                221538
      *
      * Account Servicing Institution
      *
     C                   Movel     TASI35        PASI35
     C                   Movel     TACC11        PACC11
      *
      * FX Deal Reference
      *
     C                   Movel     FXDREF        PFXDREF
      *
      * Transfer Ccy and Transfer Amount
      *
     C                   If        TRNCCY <> *Blanks
     C                   Move      TRNCCY        PTRNCCY
     C                   Move      TRNCCY        @AJCD             3
     C                   Exsr      SRCURR
      *
      * Format Amount
      *
     C                   Z-add     TRNAMT        @@AMTW           13 0
     C                   Z-add     A6NBDP        @@QECN            1 0
     C                   Exsr      SRFTAM
      *
     C                   Move      @@AMTD        PTRNAMT
     C                   Endif
      *
      * Payment Ccy and Payment Amount
      *
     C                   If        PAYCCY <> *Blanks
     C                   Move      PAYCCY        PPAYCCY
     C                   Move      PAYCCY        @AJCD             3
     C                   Exsr      SRCURR
      *
      * Format Amount
      *
     C                   Z-add     PAYAMT        @@AMTW           13 0
     C                   Z-add     A6NBDP        @@QECN            1 0
     C                   Exsr      SRFTAM
      *
     C                   Move      @@AMTD        PPAYAMT
     C                   Endif
      *
      * Exchange Rate
      *
     C                   If        XRATE <> *Zeros
      *
     C                   Move      XRATE         ZFIELD
     C                   Callb     'ZEDIT'
     C                   Parm                    ZFIELD           16
     C                   Parm      8             ZADEC             1 0
      *
     C                   Move      ZFIELD        PXRATE
     C                   Endif
      *
      * Exchange rate override indicator
      *
     C                   Move      XRATEO        PXRATEO
      *
      * Credit Value Date
      *
     C                   If        CRDVDT <> *Zeros
     C                   Z-add     CRDVDT        ZDAYNO
     C                   Exsr      SRFTDT
     C                   Move      ZDATE         PCRDVDT
     C                   Endif
      *
      * Original Ccy and Amount
      *
     C                   If        TOCCY <> *Blanks
     C                   Move      TOCCY         PTOCCY
      *
     C                   Move      TOCCY         @AJCD
     C                   Exsr      SRCURR
      *
      * Format Amount
      *
     C                   Z-add     TOOAMT        @@AMTW           13 0
     C                   Z-add     A6NBDP        @@QECN            1 0
     C                   Exsr      SRFTAM
      *
     C                   Move      @@AMTD        PTOOAMT
     C                   Endif
      *
      * Charges Account
      *
     C                   Movel     CHGACC        PCHGACC
      *
      * Detail of Charges
      *
     C                   Move      TDCHGS        PTDCHGS
      *
      * Receivers Charges Currency and amount
      *
     C                   If        RCHCCY <> *Blanks
     C                   Move      RCHCCY        PRCHCCY
      *
     C                   Move      RCHCCY        @AJCD
     C                   Exsr      SRCURR
      *
      * Format Amount
      *
     C                   Z-add     RCVCHG        @@AMTW           13 0
     C                   Z-add     A6NBDP        @@QECN            1 0
     C                   Exsr      SRFTAM
      *
     C                   Move      @@AMTD        PRCVCHG
     C                   Endif
      *
      * Receivers Charges Transfer Ccy
      *
     C                   If        RCTCCY <> *Blanks
     C                   Move      RCTCCY        PRCTCCY
      *
     C                   Move      RCTCCY        @AJCD
     C                   Exsr      SRCURR
      *
      * Format Amount
      *
     C                   Z-add     RCTCHG        @@AMTW           13 0
     C                   Z-add     A6NBDP        @@QECN            1 0
     C                   Exsr      SRFTAM
      *
     C                   Move      @@AMTD        PRCTCHG
     C                   Endif
      *
      * Receivers Charges Payment Ccy
      *
     C                   If        RCPCCY <> *Blanks
     C                   Move      RCPCCY        PRCPCCY
      *
     C                   Move      RCPCCY        @AJCD
     C                   Exsr      SRCURR
      *
      * Format Amount
      *
     C                   Z-add     RCPCHG        @@AMTW           13 0
     C                   Z-add     A6NBDP        @@QECN            1 0
     C                   Exsr      SRFTAM
      *
     C                   Move      @@AMTD        PRCPCHG
     C                   Endif
      *
      * Generate Outgoing Paymnents Flag
      *
     C                   Move      GOPFLG        PGOPFLG
      *
      * Instruction Code
      *
     C                   Movel     INSCA4        PINSCA4
     C                   Movel     INSCB4        PINSCB4
     C                   Movel     INSCC4        PINSCC4
     C                   Movel     INSCD4        PINSCD4
     C                   Movel     INSCE4        PINSCE4
     C                   Movel     INSCD4        PINSCD4
     C                   Movel     INSA31        PINSA31
     C                   Movel     INSB31        PINSB31
      *
      * Remittance Information
      *
     C                   Movel     TRMA35        PTRMA35
     C                   Movel     TRMB35        PTRMB35
     C                   Movel     TRMC35        PTRMC35
     C                   Movel     TRMD35        PTRMD35
      *
      * Regulatory Reporting
      *
     C                   Movel     TRGA35        PTRGA35
     C                   Movel     TRGB35        PTRGB35
     C                   Movel     TRGC35        PTRGC35
      *
      * User Details
      *
     C                   Movel     INUSER        PINUSER_D
      *                                                                         178384
     C**********         Movel     INDATE        PINDATE_D                      178384
     C                   If        Indate <> *Zeros                             178384
     C                   Z-add     Indate        ZDAYNO                         178384
     C                   Exsr      SRFTDT                                       178384
     C                   Move      ZDATE         PIndate_D                      178384
     C                   Endif                                                  178384
      *                                                                         178384
     C                   Movel     INTIME        PINTIME_D
     C                   Movel     UPDUSR        PUPDUSR_D
     C**********         Movel     UPDDTE        PUPDDTE_D                      178384
     C                   If        Upddte <> *Zeros                             178384
     C                   Z-add     Upddte        ZDAYNO                         178384
     C                   Exsr      SRFTDT                                       178384
     C                   Move      ZDATE         PUpddte_D                      178384
     C                   Endif                                                  178384
      *                                                                         178384
     C                   Movel     UPDTIM        PUPDTIM_D
      *
      * Message Part
      *
     C                   Z-add     RFTMSQ        PRFTMSQ
      *
      * Message Reference
      *
     C                   Z-add     RFTMSG        PRFTMRF
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** FLEMSG - Set Output File Fields with message datas
      *****************************************************************
      *
     C     FLEMSG        Begsr
      *
      * Map data of MT101
      *
      * Ordering customer
      *
     C                   If        P50 <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     P50           DSTRAN
     C                   If        TRCODE = *Blanks
     C                   Eval      TOCUS1 = TMLIN1
     C                   Eval      TOCUS2 = TMLIN2
     C                   Eval      TOCUS3 = TMLIN3
     C                   Eval      TOCUS4 = TMLIN4
     C                   Eval      TOCUS5 = TMLIN5
     C                   Else
     C                   Eval      AplyType(1) = 'F'
     C                   Eval      AplyType(2) = 'R'
     C                   Eval      AplyType(3) = 'G'
     C                   Exsr      APLYTRN
     C                   Eval      TOCUS1 = AplyValue
     C                   Endif
     C                   Endif
      *
      * Instructing party
      *
     C                   If        P50L <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     P50L          DSTRAN
     C                   If        TRCODE = *Blanks
     C                   Eval      TINPTY = TMLIN1
     C                   Else
     C                   Eval      AplyType(1) = 'C'
     C                   Exsr      APLYTRN
     C                   Eval      TINPTY = AplyValue
     C                   Endif
     C                   Endif
      *
      * Account Servicing Institution
      *
     C                   If        P52 <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     P52           DSTRAN
     C                   If        TRCODE = *Blanks
     C                   Eval      TASI35 = TMLIN1
     C                   Else
     C                   Eval      AplyType(1) = 'F'
     C                   Eval      AplyType(2) = 'R'
     C                   Eval      AplyType(3) = 'G'
     C                   Exsr      APLYTRN
     C                   Eval      TASI35 = AplyValue
     C                   Endif
     C                   Endif
      *
      * Intermediary
      *
     C                   If        P56 <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     P56           DSTRAN
     C                   If        TRCODE = *Blanks
     C                   Eval      TINST1 = TMLIN1
     C                   Eval      TINST2 = TMLIN2
     C                   Eval      TINST3 = TMLIN3
     C                   Eval      TINST4 = TMLIN4
     C                   Eval      TINST5 = TMLIN5
     C                   Else
     C                   Eval      AplyType(1) = 'F'
     C                   Eval      AplyType(2) = 'R'
     C                   Eval      AplyType(3) = 'G'
     C                   Exsr      APLYTRN
     C                   Eval      TINST1 = AplyValue
     C                   Endif
     C                   Endif
      *
      * Account with institution
      *
     C                   If        P57 <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     P57           DSTRAN
     C                   If        TRCODE = *Blanks
     C                   Eval      TACA35 = TMLIN1
     C                   Eval      TACB35 = TMLIN2
     C                   Eval      TACC35 = TMLIN3
     C                   Eval      TACE35 = TMLIN4
     C                   Else
     C                   Eval      AplyType(1) = 'F'
     C                   Eval      AplyType(2) = 'R'
     C                   Eval      AplyType(3) = 'G'
     C                   Exsr      APLYTRN
     C                   Eval      TACA35 = AplyValue
     C                   Endif
     C                   Endif
      *
      * Beneficiary
      *
     C                   If        P59 <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     P59           DSTRAN
     C                   If        TRCODE = *Blanks
     C                   Eval      TBNA35 = TMLIN1
     C                   Eval      TBNB35 = TMLIN2
     C                   Eval      TBNC35 = TMLIN3
     C                   Eval      TBND35 = TMLIN4
     C                   Eval      TBNE35 = TMLIN5
     C                   Else
     C                   Eval      AplyType(1) = 'F'
     C                   Eval      AplyType(2) = 'R'
     C                   Eval      AplyType(3) = 'G'
     C                   Exsr      APLYTRN
     C                   Eval      TBNA35 = AplyValue
     C                   Endif
     C                   Endif
      *
      * Charges account
      *
     C                   If        P25A <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     P25A          DSTRAN
     C                   If        TRCODE = *Blanks
     C                   Eval      CHGACC = TMLIN1
     C                   Else
     C                   Eval      AplyType(1) = 'F'
     C                   Eval      AplyType(2) = 'R'
     C                   Eval      AplyType(3) = 'G'
     C                   Exsr      APLYTRN
     C                   Eval      CHGACC = AplyValue
     C                   Endif
     C                   Endif
      *
      * Transaction reference
      *
     C                   If        P21 <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     P21           DSTRAN
     C                   Eval      TRNSID = TTREF
     C                   Endif
      *
      * F/X deal reference
      *
     C                   If        P21F <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     P21F          DSTRAN
     C                   Eval      FXDREF = TTREF
     C                   Endif
      *
      * Instruction code
      *
     C                   If        P23E <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     P23E          DSTRAN
     C                   Eval      INSCA4 = %subst(TMLIN1:1:4)
     C                   Eval      INSCB4 = %subst(TMLIN2:1:4)
     C                   Eval      INSCC4 = %subst(TMLIN3:1:4)
     C                   Eval      INSCD4 = %subst(TMLIN4:1:4)
     C                   Eval      INSCE4 = %subst(TMLIN5:1:4)
     C                   Eval      INSA31 = %subst(TMLIN1:5:31)
     C                   Eval      INSB31 = %subst(TMLIN2:5:31)
     C                   Endif
      *
      * Currency transaction amount
      *
     C                   If        P32B <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     P32B          DSTRAN
     C                   Eval      TRNCCY = TTCCY
     C                   Eval      Comma = %scan(',':TTAMT)
     C                   If        Comma <> 0
     C                   Eval       %subst(TTAMT:Comma:1) = '.'
     C                   Endif
 
      * Format Amount
     C                   Move      TTCCY         @AJCD             3
     C                   EXSR      SRCURR
 
     C                   Move      *Blanks       zfield
     C                   Move      TTAMT         zfield
     C                   Eval      zadec = A6NBDP
     C                   Eval      zadig = 15 - A6NBDP
     C                   Exsr      SRFAFL
 
     C                   Move      zfield        TRNAMT
 
     C                   Endif
      *
      * Remittance information
      *
     C                   If        P70 <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     P70           DSTRAN
     C                   Eval      TRMA35 = TMLIN1
     C                   Eval      TRMB35 = TMLIN2
     C                   Eval      TRMC35 = TMLIN3
     C                   Eval      TRMD35 = TMLIN4
     C                   Endif
      *
      * Regulatory reporting
      *
     C                   If        P77B <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     P77B          DSTRAN
     C                   Eval      TRGA35 = TMLIN1
     C                   Eval      TRGB35 = TMLIN2
     C                   Eval      TRGC35 = TMLIN3
     C                   Endif
      *
      * Currency original amount
      *
     C                   If        P33B <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     P33B          DSTRAN
     C                   Eval      TOCCY = TTCCY
     C                   Eval      Comma = %scan(',':TTAMT)
     C                   If        Comma <> 0
     C                   Eval       %subst(TTAMT:Comma:1) = '.'
     C                   Endif
 
      * Format Amount
     C                   Move      TOCCY         @AJCD             3
     C                   EXSR      SRCURR
 
     C                   Move      *Blanks       zfield
     C                   Move      TTAMT         zfield
     C                   Eval      zadec = A6NBDP
     C                   Eval      zadig = 15 - A6NBDP
     C                   Exsr      SRFAFL
 
     C                   Move      zfield        TOOAMT
 
     C                   Endif
      *
      * Details of charges
      *
     C                   If        P71 <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     P71           DSTRAN
     C                   Eval      TDCHGS = TTREF
     C                   Endif
      *
      * Details of charges
      *
     C                   If        P71 <> *Blanks
     C                   Reset                   DSTRAN
     C                   Movel     P71           DSTRAN
     C                   Eval      TDCHGS = TTREF
     C                   Endif
      *
      * Message Part
      *
     C                   Z-add     PHPART        RFTMSQ
      *
      * Message Reference
      *
     C                   Z-add     PHMSGR        RFTMSG
      *
      * EXCHANGE RATE CANNOT BE MAPPED FOR AN 'RI' SWIFT MESSAGE
      * SINCE THIS TAG IS FOR XRATE BETWEEN ORIG AND TRANS AMOUNT
      * BUT FOR RI's  THE XRATE ON SCREEN IS CALC BETWEEN PAY & TRANS AMT
 
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
     C                   Move      PRFTHDR       RFTID
      *                                                                         178751
      * Credit sequence number                                                  178751
      *                                                                         178751
     C                   Move      PTSEQNO       TSEQNO                         178751
      *
      * Transaction ID
      *
     C                   Move      PTRNSID       TRNSID
      *
      * Customer reference (passed as parameter)
      *
      * Beneficiary
      *
     C                   Movel     PBNA35        TBNA35
     C                   Movel     PBNB35        TBNB35
     C                   Movel     PBNC35        TBNC35
     C                   Movel     PBND35        TBND35
     C                   Movel     PBNE35        TBNE35
     C                   Movel     PBENTTP       BENTTP
      *
      * Account with Institution
      *
     C                   Movel     PACA11        TACA11
     C                   Movel     PACA35        TACA35
     C                   Movel     PACB35        TACB35
     C                   Movel     PACC35        TACC35
     C                   Movel     PACD35        TACD35
     C                   Movel     PACE35        TACE35
     C                   Movel     PAWITTP       AWITTP
      *
      * Intermediary
      *
     C                   Movel     PINSTA        TINSTA
     C                   Movel     PINST1        TINST1
     C                   Movel     PINST2        TINST2
     C                   Movel     PINST3        TINST3
     C                   Movel     PINST4        TINST4
     C                   Movel     PINST5        TINST5
     C                   Movel     PINTTTP       INTTTP
      *
      * Instructing Party
      *
     C                   Movel     PINPTY        TINPTY
      *
      * Ordering Customer
      *
     C                   Movel     POCUS1        TOCUS1
     C                   Movel     POCUS2        TOCUS2
     C                   Movel     POCUS3        TOCUS3
     C                   Movel     POCUS4        TOCUS4
     C                   Movel     POCUS5        TOCUS5
     C                   Movel     PDCUSTP       DCUSTP
      *
      * Account Servicing Institution
      *
     C                   Movel     PASI35        TASI35
     C                   Movel     PACC11        TACC11
      *
      * FX Deal Reference
      *
     C                   Movel     PFXDREF       FXDREF
      *
      * Transfer Ccy and Transfer Amount
      *
     C                   If        PTRNCCY <> *Blanks
     C                   Move      PTRNCCY       TRNCCY
      *
     C                   Move      PTRNCCY       @AJCD             3
     C                   EXSR      SRCURR
      *
      * Format Amount
      *
     C                   Move      *Blanks       zfield
     C                   Move      PTRNAMT       zfield
     C                   Eval      zadec = A6NBDP
     C                   Eval      zadig = 15 - A6NBDP
     C                   Exsr      SRFAFL
      *
     C                   Move      zfield        TRNAMT
     C                   Endif
      *
      * Payment Ccy and Payment Amount
      *
     C                   If        PPAYCCY <> *Blanks
     C                   Move      PPAYCCY       PAYCCY
      *
     C                   Move      PPAYCCY       @AJCD             3
     C                   EXSR      SRCURR
      *
      * Format Amount
      *
     C                   Move      *Blanks       zfield
     C                   Move      PPAYAMT       zfield
     C                   Eval      zadec = A6NBDP
     C                   Eval      zadig = 15 - A6NBDP
     C                   Exsr      SRFAFL
      *
     C                   Move      zfield        PAYAMT
     C                   Endif
      *
      * Exchange Rate
      *
     C                   If        PXRATE <> *Zeros
      *
     C                   Move      *Blanks       zfield
     C                   Move      PXRATE        zfield
     C                   Z-add     8             zadec
     C                   Z-add     5             zadig
     C                   Exsr      SRFAFL
      *
     C                   Move      zfield        XRATE
     C                   Endif
      *
      * Exchange rate override indicator
      *
     C                   Move      PXRATEO       XRATEO
      *
      * Credit Value Date
      *
     C                   If        PCRDVDT <> *Blanks
      *
     C                   CallB     'ZDATE1'
     C                   Parm      PCRDVDT       DateIn
     C                   Parm      *Zeros        DaynoOut
     C                   Parm      BJDFIN        DatFmt
     C                   Parm      *Blank        ErrorFlag
      *
     C                   Z-add     DaynoOut      CRDVDT
     C                   Endif
      *
      * Original Ccy and Amount
      *
     C                   If        PTOCCY <> *Blanks
     C                   Move      PTOCCY        TOCCY
      *
     C                   Move      PTOCCY        @AJCD
     C                   Exsr      SRCURR
      *
      * Format Amount
      *
     C                   Move      *Blanks       zfield
     C                   Move      PTOOAMT       zfield
     C                   Eval      zadec = A6NBDP
     C                   Eval      zadig = 15 - A6NBDP
      *
     C                   Exsr      SRFAFL
      *
     C                   Move      zfield        TOOAMT
     C                   Endif
      *
      * Charges Account
      *
     C                   Movel     PCHGACC       CHGACC
      *
      * Detail of Charges
      *
     C                   Move      PTDCHGS       TDCHGS
      *
      * Receivers Charges Currency and amount
      *
     C                   If        PRCHCCY <> *Blanks
     C                   Move      PRCHCCY       RCHCCY
      *
     C                   Move      RCHCCY        @AJCD
     C                   Exsr      SRCURR
      *
      * Format Amount
      *
     C                   Move      *Blanks       zfield
     C                   Move      PRCVCHG       zfield
     C                   Eval      zadec = A6NBDP
     C                   Eval      zadig = 13 - A6NBDP
     C                   Exsr      SRFAFL
      *
     C                   Move      zfield        RCVCHG
     C                   Endif
      *
      * Receivers Charges Transfer Ccy
      *
     C                   If        PRCTCCY <> *Blanks
     C                   Move      PRCTCCY       RCTCCY
      *
     C                   Move      RCTCCY        @AJCD
     C                   Exsr      SRCURR
      *
      * Format Amount
      *
     C                   Move      *Blanks       zfield
     C                   Move      PRCTCHG       zfield
     C                   Eval      zadec = A6NBDP
     C                   Eval      zadig = 13 - A6NBDP
     C                   Exsr      SRFAFL
      *
     C                   Move      zfield        RCTCHG
     C                   Endif
      *
      * Receivers Charges Payment Ccy
      *
     C                   If        PRCPCCY <> *Blanks
     C                   Move      PRCPCCY       RCPCCY
      *
     C                   Move      RCPCCY        @AJCD
     C                   Exsr      SRCURR
      *
      * Format Amount
      *
     C                   Move      *Blanks       zfield
     C                   Move      PRCPCHG       zfield
     C                   Eval      zadec = A6NBDP
     C                   Eval      zadig = 13 - A6NBDP
     C                   Exsr      SRFAFL
      *
     C                   Move      zfield        RCPCHG
     C                   Endif
      *
      * Generate Outgoing Payments Flag
      *
     C                   Move      PGOPFLG       GOPFLG
      *
      * Instruction Code
      *
     C                   Movel     PINSCA4       INSCA4
     C                   Movel     PINSCB4       INSCB4
     C                   Movel     PINSCC4       INSCC4
     C                   Movel     PINSCD4       INSCD4
     C                   Movel     PINSCE4       INSCE4
     C                   Movel     PINSCD4       INSCD4
     C                   Movel     PINSA31       INSA31
     C                   Movel     PINSB31       INSB31
      *
      * Remittance Information
      *
     C                   Movel     PTRMA35       TRMA35
     C                   Movel     PTRMB35       TRMB35
     C                   Movel     PTRMC35       TRMC35
     C                   Movel     PTRMD35       TRMD35
      *
      * Regulatory Reporting
      *
     C                   Movel     PTRGA35       TRGA35
     C                   Movel     PTRGB35       TRGB35
     C                   Movel     PTRGC35       TRGC35
      *                                                                         178384
      * User Details                                                            178384
      *                                                                         178384
     C                   Movel     PINUSER_D     INUSER                         178384
      *                                                                         178384
     C                   If        PIndate_D <> *Blanks                         178384
      *                                                                         178384
     C                   CallB     'ZDATE1'                                     178384
     C                   Parm      PIndate_D     DateIn                         178384
     C                   Parm      *Zeros        DaynoOut                       178384
     C                   Parm      BJDFIN        DatFmt                         178384
     C                   Parm      *Blank        ErrorFlag                      178384
      *                                                                         178384
     C                   Z-add     DaynoOut      Indate                         178384
     C                   Endif                                                  178384
      *                                                                         178384
     C                   Movel     PINTIME_D     INTIME                         178384
     C                   Movel     PUPDUSR_D     UPDUSR                         178384
      *                                                                         178384
     C                   If        PUpddte_D <> *Blanks                         178384
     C                   CallB     'ZDATE1'                                     178384
     C                   Parm      PUpddte_D     DateIn                         178384
     C                   Parm      *Zeros        DaynoOut                       178384
     C                   Parm      BJDFIN        DatFmt                         178384
     C                   Parm      *Blank        ErrorFlag                      178384
      *                                                                         178384
     C                   Z-add     DaynoOut      Upddte                         178384
     C                   Endif                                                  178384
      *                                                                         178384
     C                   Movel     PUPDTIM_D     UPDTIM                         178384
      *
      * Message Part
      *
     C                   Z-add     PRFTMSQ       RFTMSQ
      *
      * Message Reference
      *
     C                   Z-add     PRFTMRF       RFTMSG
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFTDT - Format Date for Display                            *
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
      * SRFTAM - Format Amount for Display                            *
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
      * Database Error
      *
     C                   If        @@RETC <> *Blanks
     C                   Movel     'ZA0920  '    DBFILE
     C                   Z-add     2             DBASE
     C                   Movel     @@AMTW        DBKEY
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Exsr      *PSSR
     C                   Endif
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
      * SRCURR - Retrieve Currency Details                            *
      *****************************************************************
     C     SRCURR        Begsr
      *
     C                   If        @AJCD <> *Blanks
 
     C                   Callb     'AOCURRR0'
     C                   Parm      *BLANK        @RTCD             7
     C                   Parm      '*KEY   '     @OPTN             7
     C                   Parm                    @AJCD             3
     C     SDCURR        Parm      SDCURR        DSSDY
      *
      * Database Error
      *
     C                   If        @RTCD <> *Blanks
     C                   Movel     'ZALIGN  '    DBFILE
     C                   Z-add     4             DBASE
     C                   Movel     @AJCD         DBKEY
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Exsr      *PSSR
     C                   Endif
     C                   Endif
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
     C                   PARM                    CnvTyp            2
      *
      * RFT Header Details in file format
     C                   Parm                    DRftDtl
      *
      * Message details
     C                   Parm                    PHEAD
     C                   Parm                    PDATA
     C                   PARM                    PDAT2                                        CSW209
      *
      * Output parameters
      *
      * RFT header details in screen format
     C                   PARM                    RftScnFmt
      *
      ** Initialize program name
      *
     C                   Movel     'FTM1012CT'   DBPGM
      *
      ** Access Bank Details
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
     C                   Z-add     1             DBASE
     C                   Movel     @OPTN         DBKEY
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Exsr      *PSSR
     C                   Endif
      *
     C                   Endsr
      *
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
