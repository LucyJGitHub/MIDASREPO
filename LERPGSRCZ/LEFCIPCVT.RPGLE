     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Faclty conversion - file to screen format')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFCIPCVT - LE Facility Conversion: File to Screen Format    *
      *                                                               *
      *  Function:  This module converts the fields of a Facility     *
      *             from their format as on file to a screen format.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. AR804792           Date 05Sep11               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR787620           Date 10Jun11               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23786           Date 21Apr09               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239211             Date 31Aug06               *
      *                 BUG12717           Date 22Nov06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9610            Date 14Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE034             Date 05May03               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG3815            Date 27Jul04               *
      *                 BUG3723            Date 19Jul04               *
      *                 CGP001             Date 12Jan04               *
      *                 CLE029             Date 04Sep02               *
      *                 CAP073  *CREATE    Date 180302                *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR804792 - Late Payment Penalty Spread was displayed as      *
      *             amount instead of Percentage.                     *
      *             Reinstate codes reversed by CLE106 that set up the*
      *             number of decimal places if the late penalty type *
      *             is 'P'. Applied GEMS256741 (Child: AR804793)      *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00087                                 *
      *  CLE064 - Enhancement of Lending Frequencies                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23786 - Incorrect values in Previous and Penultimate Date *
      *             fields when Facility amended in WIP (Recompile)   *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  239211 - Recompile over changes in LEFCSPPD.                 *
      *  BUG12717 - Missing Over-line Amount in user interface of     *
      *             facility screen details                           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG9610 - Initialise the facility amount screen format to    *
      *            zero when the facility amount file format is zero  *
      *            instead of blank.                                  *
      *  CLE106 - Syndications Manager                                *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompiled)                                        *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  BUG3815 - Overline percentage is being truncated             *
      *  BUG3723- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  CGP001 - Credit agreement exchange rate truncated if rate    *
      *           is greater than 999                                 *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
      *                                                               *
      *****************************************************************
      *                                                               *
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
 
      ** Include the GL standard declares
     D/COPY GLCPYSRC,STDDECLARE
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Facility FM in File Format
     D FcvmFilFmt    E DS                  EXTNAME(LEVFCIMPD)
      * Facility FN in File Format
     D FcvnFilFmt    E DS                  EXTNAME(LEVFCINPD)
 
      * Facility in Screen Format
     D FacScnPrim    E DS                  EXTNAME(LEFCPPPD)
     D FacScnSeco    E DS                  EXTNAME(LEFCSPPD)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **   CURRENCY TYPE
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *                                                                                       CER020
      ** External DS for SAR Details                                                          CER020
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER020
 
      *  DS for Drawing types
     D                 DS
     D  FPDTPS1                1      5
     D  DPDTPX1                1      6                                                      BUG3723
     D  FPDTS1                 1      1
     D  FPDTS2                 2      2
     D  FPDTS3                 3      3
     D  FPDTS4                 4      4
     D  FPDTS5                 5      5
     D  FPDTS6                 6      6                                                      BUG3723
 
      *  DS for rollover types
     D                 DS
     D  FPRTPS1                1      6
     D  FPRTS1                 1      1
     D  FPRTS2                 2      2
     D  FPRTS3                 3      3
     D  FPRTS4                 4      4
     D  FPRTS5                 5      5
     D  FPRTS6                 6      6
     D  FPRTPS2                7     21                                                       CLE064
     D  FPRTSP7                7      7                                                       CLE064
     D  FPRTSP8                8      8                                                       CLE064
     D  FPRTSP9                9      9                                                       CLE064
     D  FPRTSP0               10     10                                                       CLE064
     D  FPRTSPA               11     11                                                       CLE064
     D  FPRTSPB               12     12                                                       CLE064
     D  FPRTSPC               13     13                                                       CLE064
     D  FPRTSPD               14     14                                                       CLE064
     D  FPRTSPE               15     15                                                       CLE064
     D  FPRTSPF               16     16                                                       CLE064
     D  FPRTSPG               17     17                                                       CLE064
     D  FPRTSPH               18     18                                                       CLE064
     D  FPRTSPI               19     19                                                       CLE064
     D  FPRTSPJ               20     20                                                       CLE064
     D  FPRTSPK               21     21                                                       CLE064
 
      ** Allowable currency
     D                 DS
     D  FPALCY1                1     36
     D  FPCY01                 1      3
     D  FPCY02                 4      6
     D  FPCY03                 7      9
     D  FPCY04                10     12
     D  FPCY05                13     15
     D  FPCY06                16     18
     D  FPCY07                19     21
     D  FPCY08                22     24
     D  FPCY09                25     27
     D  FPCY10                28     30
     D  FPCY11                31     33
     D  FPCY12                34     36
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      *                                                                                       CER020
      ** Parameters for the Access Object                                                     CER020
     D PRtcd           S              7A                                                      CER020
     D POptn           S              7A                                                      CER020
     D PSard           S              6A                                                      CER020
      *                                                                                       CER020
     D CER020          S              1A                                                      CER020
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
      *
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *
      ** Set output screen fields for first screen
     C                   EXSR      SETFLD1
      *
      ** Set output screen fields for second screen
     C                   EXSR      SETFLD2
 
      * Return
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD1 - Set output for screen one
      *****************************************************************
     C     SETFLD1       BEGSR
 
      * Customer Number
     C*****              MOVEL(P)  FPCNUM        DDCSSN                                       CSD027
     C                   MOVEL     FPCNUM        DDCSSN                                       CSD027
 
      * Facility Type
     C                   MOVEL(P)  FPFACT        DDFACT
 
      * Facility Number
     C                   MOVEL(P)  FPFCNO        DDFCNO
      *
      * Fclty status
     C                   SELECT
     C     FPRECI        WHENEQ    'D'
     C     FPFSTS        ANDEQ     'C'
     C                   MOVEL     'LEF0118'     ZAMSID
     C     FPRECI        WHENEQ    'D'
     C     FPFSTS        ANDEQ     'A'
     C                   MOVEL     'LEF0119'     ZAMSID
     C     FPRECI        WHENEQ    'D'
     C     FPFSTS        ANDEQ     'R'
     C                   MOVEL     'LEF0120'     ZAMSID
     C     FPRECI        WHENEQ    'R'
     C     FPFSTS        ANDEQ     'A'
     C                   MOVEL     'LEF0121'     ZAMSID
     C     FPRECI        WHENEQ    'C'
     C     FPFSTS        ANDEQ     'A'
     C                   MOVEL     'LEF0122'     ZAMSID
     C     FPRECI        WHENEQ    'E'
     C                   MOVEL     'LEF0124'     ZAMSID
     C                   OTHER
     C                   MOVE      *BLANKS       DDFSTS
     C                   MOVE      *BLANKS       DDFST2
     C                   ENDSL
 
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTP        DDFSTS
     C                   MOVEL     ZAMSTP        DDFST2
     C                   MOVE      *BLANKS       ZAMSID
      *
      * Branch code
     C                   MOVEL(P)  FPBRCA        DDBRCA
 
      * Currency
     C                   EVAL      DDFCCY=FPFCCY
 
      * Facility amount
      *
     C                   IF        FPFAMT=*ZEROS
     C**********         EVAL      DDFAMT=*BLANKS                                            BUG9610
     C                   MOVE      '0'           DDFAMT                                      BUG9610
     C                   ELSE
      *
     C                   EVAL      ZFLD15=FPFAMT
     C                   EVAL      ZDECS=A6NBDP
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        DDFAMT
     C                   END
 
      * Overline %
     C                   IF        FPOVPC=*ZEROS
     C                   EVAL      DDOVPC=*BLANKS
     C                   ELSE
     C                   EVAL      ZFLD15=FPOVPC*1000
     C                   EVAL      ZDECS=3
     C                   EXSR      FMTAMT
     C**********         MOVE      ZOUT21        DDOVPC                                      BUG3815
     C                   EVAL      DDOVPC = %SubSt(ZOUT21:15:6)                              BUG2815
     C                   END
 
      * Over-line Amount                                                                    BUG12717
     C                   IF        FPOVAM = *ZEROS                                          BUG12717
     C                   EVAL      DDOVAM = *BLANKS                                         BUG12717
     C                   ELSE                                                               BUG12717
     C                   EVAL      ZFLD15 = FPOVAM                                          BUG12717
     C                   EVAL      ZDECS  = A6NBDP                                          BUG12717
     C                   EXSR      FMTAMT                                                   BUG12717
     C                   MOVE      ZOUT21        DDOVAM                                     BUG12717
     C                   ENDIF                                                              BUG12717
 
      * Fclty / Cmmt Ind
     C                   MOVEL(P)  FPFCTI        DDFCTI
 
      * Start date
     C                   IF        FPDTAP=*ZERO
     C                   EVAL      DDDTAP=*BLANKS
     C                   ELSE
     C                   EVAL      DAYNO=FPDTAP
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DDDTAP
     C                   END
 
      * Revolving Credit
     C                   MOVEL(P)  FPRVCR        DDRVCR
 
      * Multi currency
     C                   MOVEL(P)  FPMCCY        DDMCCY
 
      * Secured
     C                   MOVEL(P)  FPSECI        DDSECI
 
      * Expiry date
     C                   IF        FPDTEX=*ZERO
     C                   EVAL      DDDTEX=*BLANKS
     C                   ELSE
     C                   EVAL      DAYNO=FPDTEX
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DDDTEX
     C                   END
 
      * Country of Risk
     C                   MOVEL(P)  FPCRSK        DDCRSK
 
      * Multi customer
     C                   MOVEL(P)  FPMCSI        DDMCSI
 
      * Alt N/A
     C                   MOVEL(P)  FPNACD        DDNACD
 
      * Multi Branch
     C                   MOVEL(P)  FNMBFC        DDMBFC
 
      * Rev. CR Date changed
     C                   IF        FPRVCD=*ZERO
     C                   EVAL      DDRVCD=*BLANKS
     C                   ELSE
     C                   EVAL      DAYNO=FPRVCD
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DDRVCD
     C                   END
 
      * Date of last Fin. Stmt
     C                   IF        FPDLFS=*ZERO
     C                   EVAL      DDDLFS=*BLANKS
     C                   ELSE
     C                   EVAL      DAYNO=FPDLFS
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DDDLFS
     C                   END
 
      * Nominal Rate
     C                   IF        FPNOMR=*ZEROS
     C                   EVAL      DDNOMR=*BLANKS
     C                   ELSE
     C                   EVAL      ZFLD15=FPNOMR*10000000
     C                   EVAL      ZDECS=7
     C                   EXSR      FMTAMT
     C                   EVAL      DDNOMR= %SUBST(ZOUT21:9:12)
     C                   END
 
      * Review Date
     C                   IF        FPRVDT=*ZERO
     C                   EVAL      DDRVDT=*BLANKS
     C                   ELSE
     C                   EVAL      DAYNO=FPRVDT
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DDRVDT
     C                   END
 
      * Frequency
     C                   MOVEL(P)  FPRVFR        DDRVFR
 
      * Day no
     C                   IF        FPRVDY=*ZEROS
     C                   EVAL      DDRVDY=*BLANKS
     C                   ELSE
     C                   MOVEL(P)  FPRVDY        DDRVDY
     C                   END
 
      * Account officer
     C                   MOVEL(P)  FPACOF        DDACOF
 
      * Profit Center
     C                   MOVEL(P)  FNPRFC        DDPRFC
 
      * Originating Branch
     C                   MOVEL(P)  FPORBR        DDORBR
 
      * Tranche/Credit agreement Ind
     C                   MOVEL(P)  FPTRCA        DDTRCA
 
      * Credit agreement Customer
     C**********         IF        FPCANM=*ZEROS                                              CSD027
     C                   IF        FPCANM=*BLANKS                                             CSD027
     C                   EVAL      DDCANM=*BLANKS
     C                   ELSE
     C*****              MOVEL(P)  FPCANM        DDCANM                                       CSD027
     C                   MOVEL     FPCANM        DDCANM                                       CSD027
     C                   END
 
      * Credit agreement type
     C                   IF        FPCAFT=*ZEROS
     C                   EVAL      DDCAFT=*BLANKS
     C                   ELSE
     C                   MOVEL(P)  FPCAFT        DDCAFT
     C                   END
 
      * Credit agreement No
     C                   IF        FPCAFN=*ZEROS
     C                   EVAL      DDCAFN=*BLANKS
     C                   ELSE
     C                   MOVEL(P)  FPCAFN        DDCAFN
     C                   END
 
      * Narrative 1
     C                   MOVEL(P)  FPNAR1        DDNAR1
 
      * Narrative 2
     C                   MOVEL(P)  FPNAR2        DDNAR2
 
      * Narrative 3
     C                   MOVEL(P)  FPNAR3        DDNAR3
 
      * Narrative 4
     C                   MOVEL(P)  FPNAR4        DDNAR4
 
      * Bill/Tlex ind
     C                   MOVEL(P)  FNBTIN        DDBTIN
 
      * Billing days
     C                   IF        FNBLDY=*ZEROS
     C                   EVAL      DDBLDY=*BLANKS
     C                   ELSE
     C                   MOVEL(P)  FNBLDY        DDBLDY
     C                   END
 
      * Account sequence Number
     C                   IF        FPACSQ=*ZEROS
     C                   EVAL      DDACSQ=*BLANKS
     C                   ELSE
     C                   MOVEL(P)  FPACSQ        DDACSQ
     C                   END
      *                                                                                       CLE106
      ** Participant Facility Indicator                                                       CLE106
      *                                                                                       CLE106
     C                   MOVEL(P)  FPPRTR        DDPRTR                                       CLE106
      *                                                                                       CER020
      ** Previous and Penultimate Expiry Dates                                                CER020
      *                                                                                       CER020
     C                   IF        CER020 = 'Y'                                               CER020
      *                                                                                       CER020
     C                   IF        FPPEXD = *ZEROS                                            CER020
      *                                                                                       CER020
     C                   EVAL      DDPEXD = *BLANKS                                           CER020
     C                   ELSE                                                                 CER020
      *                                                                                       CER020
     C                   EVAL      DAYNO = FPPEXD                                             CER020
     C                   EXSR      CVTDAT                                                     CER020
     C                   MOVEL     ZDATE         DDPEXD                                       CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   IF        FPPNXD = *ZEROS                                            CER020
      *                                                                                       CER020
     C                   EVAL      DDPNXD = *BLANKS                                           CER020
     C                   ELSE                                                                 CER020
      *                                                                                       CER020
     C                   EVAL      DAYNO = FPPNXD                                             CER020
     C                   EXSR      CVTDAT                                                     CER020
     C                   MOVEL     ZDATE         DDPNXD                                       CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
     C/COPY WNCPYSRC,LEH00087
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD2 - Output for screen 2
      *****************************************************************
     C     SETFLD2       BEGSR
 
      * Syndication ind.
     C                   MOVEL(P)  FPSYIN        DDSYIN
 
      * Syndication complete
     C                   MOVEL(P)  FPSYCP        DDSYCP
 
      * Agent Customer number
     C**********         IF        FPANUM=*ZEROS                                              CSD027
     C                   IF        FPANUM=*BLANKS                                             CSD027
     C                   EVAL      DDANUM=*BLANKS
     C                   ELSE
     C*****              MOVEL(P)  FPANUM        DDANUM                                       CSD027
     C                   MOVEL     FPANUM        DDANUM                                       CSD027
     C                   END
 
      * Drawing table
     C     CLE028        IFEQ      'Y'                                                       BUG3723
     C                   MOVEL(P)  DPDTPX        DPDTPX1                                     BUG3723
     C                   ELSE                                                                BUG3723
     C                   MOVEL(P)  FPDTPS        FPDTPS1
     C                   ENDIF                                                               BUG3723
 
      * Drawing type 1
     C                   MOVEL(P)  FPDTS1        DDDTS1
 
      * Drawing type 2
     C                   MOVEL(P)  FPDTS2        DDDTS2
 
      * Drawing type 3
     C                   MOVEL(P)  FPDTS3        DDDTS3
 
      * Drawing type 4
     C                   MOVEL(P)  FPDTS4        DDDTS4
 
      * Drawing type 5
     C                   MOVEL(P)  FPDTS5        DDDTS5
 
      * Drawing type 5
     C                   MOVEL(P)  FPDTS5        DDDTS5
 
      * Drawing type 6                                                                       BUG3723
     C     CLE028        IFEQ      'Y'                                                       BUG3723
     C                   MOVEL(P)  FPDTS6        DDDTS6                                      BUG3723
     C                   ENDIF                                                               BUG3723
 
      * Default Interest basis
     C                   MOVEL(P)  FPDICB        DDDICB
 
      * Rollover table
     C                   MOVEL(P)  FPRTPS        FPRTPS1
     C                   MOVEL(P)  FPRTS15       FPRTPS2                                      CLE064
 
      * Rollover type 1
     C                   MOVEL(P)  FPRTS1        DDRTS1
 
      * Rollover type 2
     C                   MOVEL(P)  FPRTS2        DDRTS2
 
      * Rollover type 3
     C                   MOVEL(P)  FPRTS3        DDRTS3
 
      * Rollover type 4
     C                   MOVEL(P)  FPRTS4        DDRTS4
 
      * Rollover type 5
     C                   MOVEL(P)  FPRTS5        DDRTS5
 
      * Rollover type 6
     C                   MOVEL(P)  FPRTS6        DDRTS6
                                                                                              CLE064
      * Rollover type 7                                                                       CLE064
     C                   MOVEL(P)  FPRTSP7       DDRTS7                                       CLE064
                                                                                              CLE064
      * Rollover type 8                                                                       CLE064
     C                   MOVEL(P)  FPRTSP8       DDRTS8                                       CLE064
                                                                                              CLE064
      * Rollover type 9                                                                       CLE064
     C                   MOVEL(P)  FPRTSP9       DDRTS9                                       CLE064
                                                                                              CLE064
      * Rollover type 10                                                                      CLE064
     C                   MOVEL(P)  FPRTSP0       DDRTS0                                       CLE064
                                                                                              CLE064
      * Rollover type 11                                                                      CLE064
     C                   MOVEL(P)  FPRTSPA       DDRTSA                                       CLE064
                                                                                              CLE064
      * Rollover type 12                                                                      CLE064
     C                   MOVEL(P)  FPRTSPB       DDRTSB                                       CLE064
                                                                                              CLE064
      * Rollover type 13                                                                      CLE064
     C                   MOVEL(P)  FPRTSPC       DDRTSC                                       CLE064
                                                                                              CLE064
      * Rollover type 14                                                                      CLE064
     C                   MOVEL(P)  FPRTSPD       DDRTSD                                       CLE064
                                                                                              CLE064
      * Rollover type 15                                                                      CLE064
     C                   MOVEL(P)  FPRTSPE       DDRTSE                                       CLE064
                                                                                              CLE064
      * Rollover type 16                                                                      CLE064
     C                   MOVEL(P)  FPRTSPF       DDRTSF                                       CLE064
                                                                                              CLE064
      * Rollover type 17                                                                      CLE064
     C                   MOVEL(P)  FPRTSPG       DDRTSG                                       CLE064
                                                                                              CLE064
      * Rollover type 18                                                                      CLE064
     C                   MOVEL(P)  FPRTSPH       DDRTSH                                       CLE064
                                                                                              CLE064
      * Rollover type 19                                                                      CLE064
     C                   MOVEL(P)  FPRTSPI       DDRTSI                                       CLE064
                                                                                              CLE064
      * Rollover type 20                                                                      CLE064
     C                   MOVEL(P)  FPRTSPJ       DDRTSJ                                       CLE064
                                                                                              CLE064
      * Rollover type 21                                                                      CLE064
     C                   MOVEL(P)  FPRTSPK       DDRTSK                                       CLE064
 
      * Irregular Rollover period
     C                   MOVEL(P)  FPRLPD        DDRLPD
 
      * Loan administrator id
     C                   MOVEL(P)  FPLAID        DDLAID
 
      * Currency selection
     C                   MOVEL(P)  FPCSEL        DDCSEL
 
      * Currency table
     C                   MOVEL(P)  FPALCY        FPALCY1
 
      * Allowable currency 1
     C                   MOVEL(P)  FPCY01        DDCY01
 
      * Allowable currency 2
     C                   MOVEL(P)  FPCY02        DDCY02
 
      * Allowable currency 3
     C                   MOVEL(P)  FPCY03        DDCY03
 
      * Allowable currency 4
     C                   MOVEL(P)  FPCY04        DDCY04
 
      * Allowable currency 5
     C                   MOVEL(P)  FPCY05        DDCY05
 
      * Allowable currency 6
     C                   MOVEL(P)  FPCY06        DDCY06
 
      * Allowable currency 7
     C                   MOVEL(P)  FPCY07        DDCY07
 
      * Allowable currency 8
     C                   MOVEL(P)  FPCY08        DDCY08
 
      * Allowable currency 9
     C                   MOVEL(P)  FPCY09        DDCY09
 
      * Allowable currency 10
     C                   MOVEL(P)  FPCY10        DDCY10
 
      * Allowable currency 11
     C                   MOVEL(P)  FPCY11        DDCY11
 
      * Allowable currency 12
     C                   MOVEL(P)  FPCY12        DDCY12
 
      * Approval date
     C                   IF        FPCOMD=*ZERO
     C                   EVAL      DDCOMD=*BLANKS
     C                   ELSE
     C                   EVAL      DAYNO=FPCOMD
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DDCOMD
     C                   END
 
      * Closing date
     C                   IF        FPCDTE=*ZERO
     C                   EVAL      DDCDTE=*BLANKS
     C                   ELSE
     C                   EVAL      DAYNO=FPCDTE
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DDCDTE
     C                   END
 
      * Last Availability date
     C                   IF        FPAVLD=*ZERO
     C                   EVAL      DDAVLD=*BLANKS
     C                   ELSE
     C                   EVAL      DAYNO=FPAVLD
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DDAVLD
     C                   END
 
      * Late payment Penalty type
     C                   MOVEL(P)  FPLPTP        DDLPTP
 
      * Base rate
     C                   IF        FPLPBR=*ZERO
     C                   EVAL      DDLPBR=*BLANKS
     C                   ELSE
     C                   MOVEL(P)  FPLPBR        DDLPBR
     C                   END
 
      *  Late Payment Penalty Amount
      *
     C                   IF        FPLPAM=*ZEROS
     C                   EVAL      DDLPAM=*BLANKS
     C                   ELSE
      *
     C                   EVAL      ZFLD15=FPLPAM
     C*****DDLPTP        IFEQ      'P'                                                        CLE106
     C**********         EVAL      ZDECS=7                                                    CLE106
     C**********         ELSE                                                                 CLE106
     C     DDLPTP        IFEQ      'P'                                                      AR804792
     C                   EVAL      ZDECS=7                                                  AR804792
     C                   ELSE                                                               AR804792
     C                   EVAL      ZDECS=A6NBDP
     C                   ENDIF                                                              AR804792
     C**********         END                                                                  CLE106
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        DDLPAM
     C                   END
 
      * Late payment Penalty type sign
     C                   MOVEL(P)  FPLPPS        DDLPPS
 
      * Default Part.Loan type
     C                   MOVEL(P)  FPDFTP        DDDFTP
 
      * Default Part.Loan Sub type
     C                   MOVEL(P)  FPDFST        DDDFST
                                                                                              CLE042
      * Default Part.Loan Class                                                               CLE042
     C                   MOVEL(P)  FPDFCL        DDDFCL                                       CLE042
 
      * C/A Exchange rate
     C                   IF        FPCAXR=*ZEROS
     C                   EVAL      DDCAXR=*BLANKS
     C                   ELSE
     C                   EVAL      ZFLD15=FPCAXR*100000000
     C                   EVAL      ZDECS=8
     C                   EXSR      FMTAMT
     C**********         EVAL      DDCAXR= %SUBST(ZOUT21:9:12)                                CGP001
     C                   EVAL      DDCAXR= %SUBST(ZOUT21:8:13)                                CGP001
     C                   END
 
      * Exchange rate ind
     C                   MOVEL(P)  FPCMDI        DDCMDI
 
      * Severity code
     C                   MOVEL(P)  FPSVCD        DDSVCD
 
      * Limit ID
     C                   MOVEL(P)  FPLMTI        DDLMTI
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRTEXT  -  Set up text from message file.                     *
      *****************************************************************
     C     SRTEXT        BEGSR
      *
     C                   CALL      'Y2RVMGC'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM      'LERMSGF '    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP          132            Messge text
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTDAT - CONVERT DATE FROM Midas no. to DDMMYY (OR MMDDYY)    *
      *****************************************************************
     C     CVTDAT        BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    DAYNO             5 0          Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM                    ZDATE             6 0          Value date
     C                   PARM      *ZEROS        ZADATE            7            Run-date in DDM
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM                    ZOUT21           21
      *
     C                   EVAL      ZFLD15 = *ZEROS
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** BLANK OUTPUTS (EXCEPT FOR ACTION CODE WITHIN ACCOUNT FORMAT)
      *
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   MOVEL     *BLANK        FacScnPrim
     C                   MOVEL     *BLANK        FacScnSeco
     C                   MOVEL     ##ACTN        DDACTN
      *
      ** Get the currency decimal places of accounting ccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      FPFCCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     FPFCCY        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   EXSR      *PSSR                                        ************
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Facility FM in file formats
     C                   PARM                    FcvmFilFmt
      * Facility FN in file formats
     C                   PARM                    FcvnFilFmt
      *
      * Output parameters
      *
      * Facility in screen format
     C                   PARM                    FacScnPrim
     C                   PARM                    FacScnSeco
      *
      ** Initialize program name
      *
     C                   MOVEL     'LEFCIPCVT'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *                                                                                      BUG3723
      ** Access Switchable SAR details for the existence of CLE028                           BUG3723
      *                                                                                      BUG3723
     C                   CALLB     'AOSARDR0'                                                BUG3723
     C                   PARM      *BLANK        @RTCD                                       BUG3723
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3723
     C                   PARM      'CLE028'      @SARD                                       BUG3723
      *                                                                                      BUG3723
     C     @RTCD         IFEQ      *BLANKS                                                   BUG3723
     C                   MOVE      'Y'           CLE028            1                         BUG3723
     C                   ELSE                                                                BUG3723
     C                   MOVE      'N'           CLE028                                      BUG3723
     C                   ENDIF                                                               BUG3723
      *                                                                                      CER020
      ** Check for the Switchable feature CER020                                             CER020
      *                                                                                      CER020
     C                   CALLB     'AOSARDR0'                                                CER020
     C                   PARM      *BLANKS       PRtcd                                       CER020
     C                   PARM      '*VERIFY'     POptn                                       CER020
     C                   PARM      'CER020'      PSard                                       CER020
     C     SCSARD        PARM      SCSARD        DSFDY                                       CER020
      *                                                                                      CER020
     C                   IF        PRtcd = *BLANKS                                           CER020
      *                                                                                      CER020
     C                   EVAL      CER020 = 'Y'                                              CER020
     C                   ELSE                                                                CER020
     C                   EVAL      CER020 = 'N'                                              CER020
      *                                                                                      CER020
     C                   ENDIF                                                               CER020
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
(c) Misys International Banking Systems Ltd. 2002
