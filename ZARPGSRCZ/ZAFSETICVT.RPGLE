     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Further Settle Ins Conversion:File>Scrn')     *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  ZAFSETICVT - Further Settlement Instructions conversion:     *
      *               File to Screen format                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 15Feb17               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 MD024886           Date 10Feb14               *
      *                 MD023371           Date 13Nov13               *
      *                 AR1096456          Date 25Mar13               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL018             Date 03Feb04               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  MD024886 - Error encountered on decimal separator on         *
      *             further settlement amounts                        *
      *  MD023371 - Incorrect total amount is displayed on DEALS      *
      *             ENQUIRY under further settlement details          *
      *  AR1096456 - Input details of further receipt changes to      *
      *              another value when enquired                      *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *                                                               *
      *****************************************************************
 
     FDLFSACL0  IF   E           K DISK
      ** Deals Further Settlement Accounts
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D NwDlFilFmt    E DS                  EXTNAME(MMVLDNIPD)
      ** Deal in File Format
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for Currency details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** External DS for Long Dummy Data Structure
 
     D #FRECS        E DS                  EXTNAME(SDFSSRPD)
      ** Screen - Receive Further Settlement Instructions
 
     D #FPAYS        E DS                  EXTNAME(SDFSSPPD)
      ** Screen - Payment Further Settlement Instructions
 
     D ACCT          E DS                  EXTNAME(ACCNTAB)                                  CSF011A
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                 CSF011A
     D                                     PREFIX(C_)                                        CSF011A
      ** External DS for Currency details                                                    CSF011A
                                                                                            MD024886
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                MD024886
      ** External DS for Dealing details                                                    MD024886
                                                                                            MD024886
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   MD024886
      ** External DS for Short Dummy Data Structure                                         MD024886
                                                                                             CSF011A
     D                 DS                                                                    CSF011A
     D  A#OURA                       21                                                      CSF011A
     D  A#BRCA                 1      3                                                      CSF011A
     D  A#CNUM                 4      9                                                      CSF011A
     D  A#ACOD                10     19                                                      CSF011A
     D  A#ACSQ                20     21                                                      CSF011A
     D  A#RENO                 1     10                                                      CSF011A
     D  A#REST                11     21                                                      CSF011A
     D WSRACT          S             21A   DIM(12)                                           CSF011A
      ** Array for the Receipt Accounts                                                      CSF011A
                                                                                             CSF011A
     D WSPACT          S             21A   DIM(12)                                           CSF011A
      ** Array for the Payment Accounts                                                      CSF011A
                                                                                             CSF011A
     D @CSCN           S             10                                                      CSF011A
     D @KYST           S              7                                                      CSF011A
     D SETTF           S              1    INZ(*BLANKS)                                      CSF011A
     D CusIdxA         S              4S 0                                                   CSF011A
     D CusIdxB         S              4S 0                                                   CSF011A
     D CusIdxC         S              4S 0                                                   CSF011A
     D CusIdxD         S              4S 0                                                   CSF011A
     D CusIdxE         S              4S 0                                                   CSF011A
     D W@Len           S              4S 0                                                   CSF011A
     D Wx              S              2P 0                                                   CSF011A
     D***PACID**         S              7                                          CSF011A AR1096456
     D***PCYCD**         S             10                                          CSF011A AR1096456
     D***PACCD**         S              3                                          CSF011A AR1096456
     D***PACSN**         S             10                                          CSF011A AR1096456
     D***PBRCA**         S              2                                          CSF011A AR1096456
     D***PTYPE**         S              3                                          CSF011A AR1096456
     D***PNOSN**         S              7                                          CSF011A AR1096456
     D PACID           S             10  0                                                 AR1096456
     D PCYCD           S              3                                                    AR1096456
     D PACCD           S             10                                                    AR1096456
     D PACSN           S              2                                                    AR1096456
     D PBRCA           S              3                                                    AR1096456
     D PTYPE           S              7                                                    AR1096456
     D PNOSN           S              2                                                    AR1096456
                                                                                             CSF011A
      ** Parameters for call to ZA0921                                                      MD024886
     D  P#Retc         S             10A                                                    MD024886
     D  P#Amtw         S             15  0                                                  MD024886
     D  P#Decp         S              1  0                                                  MD024886
     D  P#Amtd         S             16A                                                    MD024886
     D  P#Amtp         S             17A                                                    MD024886
                                                                                            MD024886
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialize all Screen Instructions
 
     C                   EXSR      INITSC
 
      ** Access Further Settlement Instructions file and convert if found
 
     C                   MOVE      ##DLNO        PDLNO             6 0
     C     PDLNO         CHAIN     DLFSACL0                           90
     C     *IN90         IFEQ      *OFF
 
      ** Convert Receive Further Settlement Ins from File to Screen format
 
     C                   CLEAR                   #FRECS
     C                   EXSR      CVTREC
 
      ** Convert Payment Further Settlement Ins from File to Screen format
 
     C                   CLEAR                   #FPAYS
     C                   EXSR      CVTPAY
     C                   ENDIF
 
      ** Return
 
     C                   SETON                                        LR                    MD023371
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * CVTREC - Convert Receive Further Settlement Instructions      *
      *                                                               *
      *****************************************************************
     C     CVTREC        BEGSR
      *
      ** Output Total Amount
      *
      ** If Deposit Deal, only Principal is allowed on Receipt side
     C                   IF        DLTYPE = 'IT' OR DLTYPE = 'TD'
     C                   MOVE      UAMNP         PAmtInRec
     C                   ENDIF
      *
     C**********         Z-ADD     RNBDP         ZADEC                                      MD024886
     C                   Z-ADD     RNBDP         ZADEC             1 0                      MD024886
      *
     C     RUAC          IFNE      *BLANKS
     C                   MOVE(P)   PAmtInRec     ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRTAMT
     C                   ELSE
     C                   MOVE      *BLANKS       DRTAMT
     C                   ENDIF
      *
      ** Move Accounts to Display fields
      *
     C                   MOVE      RUAC          DRUAC
     C                   MOVE      RAC01         DRAC01
     C                   MOVE      RAC02         DRAC02
     C                   MOVE      RAC03         DRAC03
     C                   MOVE      RAC04         DRAC04
     C                   MOVE      RAC05         DRAC05
     C                   MOVE      RAC06         DRAC06
     C                   MOVE      RAC07         DRAC07
     C                   MOVE      RAC08         DRAC08
     C                   MOVE      RAC09         DRAC09
     C                   MOVE      RAC10         DRAC10
     C                   MOVE      RAC11         DRAC11
     C                   MOVE      RAC12         DRAC12
                                                                                             CSF011A
      ** Retrieve Customer Name Input Details                                                CSF011A
                                                                                             CSF011A
     C                   EVAL      Wx = 1                                                    CSF011A
     C                   EVAL      SETTF = 'R'                                               CSF011A
     C                   EXSR      SRLOADR                                                   CSF011A
     C                   EXSR      SRSETCNI                                                  CSF011A
                                                                                             CSF011A
     C                   DOW       Wx <= 12                                                  CSF011A
     C                   IF        WSRACT(Wx) <> *BLANKS                                     CSF011A
     C                   MOVEL     WSRACT(Wx)    A#OURA                                      CSF011A
     C                   IF        ##RCCY = *BLANKS                                          CSF011A
     C                   MOVE      IKCCY         PCYCD                                       CSF011A
     C                   ELSE                                                                CSF011A
     C                   MOVE      ##RCCY        PCYCD                                       CSF011A
     C                   ENDIF                                                               CSF011A
     C                   EXSR      SROURACT                                                  CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ADD       1             Wx                                          CSF011A
     C                   ENDDO                                                               CSF011A
      *
      ** Move Allocations to Display fields
      *
     C                   MOVE      RAL01         DRAL01
     C                   MOVE      RAL02         DRAL02
     C                   MOVE      RAL03         DRAL03
     C                   MOVE      RAL04         DRAL04
     C                   MOVE      RAL05         DRAL05
     C                   MOVE      RAL06         DRAL06
     C                   MOVE      RAL07         DRAL07
     C                   MOVE      RAL08         DRAL08
     C                   MOVE      RAL09         DRAL09
     C                   MOVE      RAL10         DRAL10
     C                   MOVE      RAL11         DRAL11
     C                   MOVE      RAL12         DRAL12
      *
      ** Convert Percentages for Display
      *
     C                   Z-ADD     3             ZADEC
      *
     C     RPC01         IFNE      0
     C                   MOVE(P)   RPC01         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRPC01
     C                   ELSE
     C                   MOVE      *BLANKS       DRPC01
     C                   ENDIF
      *
     C     RPC02         IFNE      0
     C                   MOVE(P)   RPC02         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRPC02
     C                   ELSE
     C                   MOVE      *BLANKS       DRPC02
     C                   ENDIF
      *
     C     RPC03         IFNE      0
     C                   MOVE(P)   RPC03         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRPC03
     C                   ELSE
     C                   MOVE      *BLANKS       DRPC03
     C                   ENDIF
      *
     C     RPC04         IFNE      0
     C                   MOVE(P)   RPC04         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRPC04
     C                   ELSE
     C                   MOVE      *BLANKS       DRPC04
     C                   ENDIF
      *
     C     RPC05         IFNE      0
     C                   MOVE(P)   RPC05         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRPC05
     C                   ELSE
     C                   MOVE      *BLANKS       DRPC05
     C                   ENDIF
      *
     C     RPC06         IFNE      0
     C                   MOVE(P)   RPC06         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRPC06
     C                   ELSE
     C                   MOVE      *BLANKS       DRPC06
     C                   ENDIF
      *
     C     RPC07         IFNE      0
     C                   MOVE(P)   RPC07         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRPC07
     C                   ELSE
     C                   MOVE      *BLANKS       DRPC07
     C                   ENDIF
      *
     C     RPC08         IFNE      0
     C                   MOVE(P)   RPC08         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRPC08
     C                   ELSE
     C                   MOVE      *BLANKS       DRPC08
     C                   ENDIF
      *
     C     RPC09         IFNE      0
     C                   MOVE(P)   RPC09         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRPC09
     C                   ELSE
     C                   MOVE      *BLANKS       DRPC09
     C                   ENDIF
      *
     C     RPC10         IFNE      0
     C                   MOVE(P)   RPC10         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRPC10
     C                   ELSE
     C                   MOVE      *BLANKS       DRPC10
     C                   ENDIF
      *
     C     RPC11         IFNE      0
     C                   MOVE(P)   RPC11         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRPC11
     C                   ELSE
     C                   MOVE      *BLANKS       DRPC11
     C                   ENDIF
      *
     C     RPC12         IFNE      0
     C                   MOVE(P)   RPC12         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRPC12
     C                   ELSE
     C                   MOVE      *BLANKS       DRPC12
     C                   ENDIF
      *
      ** Convert Amounts for Display
      *
     C                   Z-ADD     RNBDP         ZADEC
      *
     C     RAM01         IFNE      0
     C                   MOVE(P)   RAM01         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRAM01
     C                   ELSE
     C                   MOVE      *BLANKS       DRAM01
     C                   ENDIF
      *
     C     RAM02         IFNE      0
     C                   MOVE(P)   RAM02         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRAM02
     C                   ELSE
     C                   MOVE      *BLANKS       DRAM02
     C                   ENDIF
      *
     C     RAM03         IFNE      0
     C                   MOVE(P)   RAM03         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRAM03
     C                   ELSE
     C                   MOVE      *BLANKS       DRAM03
     C                   ENDIF
      *
     C     RAM04         IFNE      0
     C                   MOVE(P)   RAM04         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRAM04
     C                   ELSE
     C                   MOVE      *BLANKS       DRAM04
     C                   ENDIF
      *
     C     RAM05         IFNE      0
     C                   MOVE(P)   RAM05         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRAM05
     C                   ELSE
     C                   MOVE      *BLANKS       DRAM05
     C                   ENDIF
      *
     C     RAM06         IFNE      0
     C                   MOVE(P)   RAM06         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRAM06
     C                   ELSE
     C                   MOVE      *BLANKS       DRAM06
     C                   ENDIF
      *
     C     RAM07         IFNE      0
     C                   MOVE(P)   RAM07         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRAM07
     C                   ELSE
     C                   MOVE      *BLANKS       DRAM07
     C                   ENDIF
      *
     C     RAM08         IFNE      0
     C                   MOVE(P)   RAM08         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRAM08
     C                   ELSE
     C                   MOVE      *BLANKS       DRAM08
     C                   ENDIF
      *
     C     RAM09         IFNE      0
     C                   MOVE(P)   RAM09         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRAM09
     C                   ELSE
     C                   MOVE      *BLANKS       DRAM09
     C                   ENDIF
      *
     C     RAM10         IFNE      0
     C                   MOVE(P)   RAM10         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRAM10
     C                   ELSE
     C                   MOVE      *BLANKS       DRAM10
     C                   ENDIF
      *
     C     RAM11         IFNE      0
     C                   MOVE(P)   RAM11         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRAM11
     C                   ELSE
     C                   MOVE      *BLANKS       DRAM11
     C                   ENDIF
      *
     C     RAM12         IFNE      0
     C                   MOVE(P)   RAM12         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DRAM12
     C                   ELSE
     C                   MOVE      *BLANKS       DRAM12
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * CVTPAY - Convert Payment Further Settlement Instructions      *
      *                                                               *
      *****************************************************************
     C     CVTPAY        BEGSR
      *
      ** Output Total Amount
      *
      ** If Loan Deal, only Principal is allowed on Payment side
     C                   IF        DLTYPE = 'IP' OR DLTYPE = 'TI'
     C                   MOVE      UAMNP         PAmtInPay
     C                   ENDIF
      *
     C                   Z-ADD     PNBDP         ZADEC
      *
     C     PUAC          IFNE      *BLANKS
     C                   MOVE(P)   PAmtInPay     ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPTAMT
     C                   ELSE
     C                   MOVE      *BLANKS       DPTAMT
     C                   ENDIF
      *
      ** Move Accounts to Display fields
      *
     C                   MOVE      PUAC          DPUAC
     C                   MOVE      PAC01         DPAC01
     C                   MOVE      PAC02         DPAC02
     C                   MOVE      PAC03         DPAC03
     C                   MOVE      PAC04         DPAC04
     C                   MOVE      PAC05         DPAC05
     C                   MOVE      PAC06         DPAC06
     C                   MOVE      PAC07         DPAC07
     C                   MOVE      PAC08         DPAC08
     C                   MOVE      PAC09         DPAC09
     C                   MOVE      PAC10         DPAC10
     C                   MOVE      PAC11         DPAC11
     C                   MOVE      PAC12         DPAC12
                                                                                             CSF011A
      ** Retrieve Customer Name Input Details                                                CSF011A
                                                                                             CSF011A
     C                   EVAL      Wx = 1                                                    CSF011A
     C                   EVAL      SETTF = 'P'                                               CSF011A
     C                   EXSR      SRLOADP                                                   CSF011A
     C                   EXSR      SRSETCNI                                                  CSF011A
                                                                                             CSF011A
     C                   DOW       Wx <= 12                                                  CSF011A
     C                   IF        WSPACT(Wx) <> *BLANKS                                     CSF011A
     C                   MOVEL     WSPACT(Wx)    A#OURA                                      CSF011A
     C                   IF        ##PCCY = *BLANKS                                          CSF011A
     C                   MOVE      IKCCY         PCYCD                                       CSF011A
     C                   ELSE                                                                CSF011A
     C                   MOVE      ##PCCY        PCYCD                                       CSF011A
     C                   ENDIF                                                               CSF011A
     C                   EXSR      SROURACT                                                  CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ADD       1             Wx                                          CSF011A
     C                   ENDDO                                                               CSF011A
      *
      ** Move Allocations to Display fields
      *
     C                   MOVE      PAL01         DPAL01
     C                   MOVE      PAL02         DPAL02
     C                   MOVE      PAL03         DPAL03
     C                   MOVE      PAL04         DPAL04
     C                   MOVE      PAL05         DPAL05
     C                   MOVE      PAL06         DPAL06
     C                   MOVE      PAL07         DPAL07
     C                   MOVE      PAL08         DPAL08
     C                   MOVE      PAL09         DPAL09
     C                   MOVE      PAL10         DPAL10
     C                   MOVE      PAL11         DPAL11
     C                   MOVE      PAL12         DPAL12
      *
      ** Convert Percentages for Display
      *
     C                   Z-ADD     3             ZADEC
      *
     C     PPC01         IFNE      0
     C                   MOVE(P)   PPC01         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPPC01
     C                   ELSE
     C                   MOVE      *BLANKS       DPPC01
     C                   ENDIF
      *
     C     PPC02         IFNE      0
     C                   MOVE(P)   PPC02         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPPC02
     C                   ELSE
     C                   MOVE      *BLANKS       DPPC02
     C                   ENDIF
      *
     C     PPC03         IFNE      0
     C                   MOVE(P)   PPC03         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPPC03
     C                   ELSE
     C                   MOVE      *BLANKS       DPPC03
     C                   ENDIF
      *
     C     PPC04         IFNE      0
     C                   MOVE(P)   PPC04         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPPC04
     C                   ELSE
     C                   MOVE      *BLANKS       DPPC04
     C                   ENDIF
      *
     C     PPC05         IFNE      0
     C                   MOVE(P)   PPC05         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPPC05
     C                   ELSE
     C                   MOVE      *BLANKS       DPPC05
     C                   ENDIF
      *
     C     PPC06         IFNE      0
     C                   MOVE(P)   PPC06         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPPC06
     C                   ELSE
     C                   MOVE      *BLANKS       DPPC06
     C                   ENDIF
      *
     C     PPC07         IFNE      0
     C                   MOVE(P)   PPC07         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPPC07
     C                   ELSE
     C                   MOVE      *BLANKS       DPPC07
     C                   ENDIF
      *
     C     PPC08         IFNE      0
     C                   MOVE(P)   PPC08         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPPC08
     C                   ELSE
     C                   MOVE      *BLANKS       DPPC08
     C                   ENDIF
      *
     C     PPC09         IFNE      0
     C                   MOVE(P)   PPC09         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPPC09
     C                   ELSE
     C                   MOVE      *BLANKS       DPPC09
     C                   ENDIF
      *
     C     PPC10         IFNE      0
     C                   MOVE(P)   PPC10         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPPC10
     C                   ELSE
     C                   MOVE      *BLANKS       DPPC10
     C                   ENDIF
      *
     C     PPC11         IFNE      0
     C                   MOVE(P)   PPC11         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPPC11
     C                   ELSE
     C                   MOVE      *BLANKS       DPPC11
     C                   ENDIF
      *
     C     PPC12         IFNE      0
     C                   MOVE(P)   PPC12         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPPC12
     C                   ELSE
     C                   MOVE      *BLANKS       DPPC12
     C                   ENDIF
      *
      ** Convert Amounts for Display
      *
     C                   Z-ADD     PNBDP         ZADEC
      *
     C     PAM01         IFNE      0
     C                   MOVE(P)   PAM01         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPAM01
     C                   ELSE
     C                   MOVE      *BLANKS       DPAM01
     C                   ENDIF
      *
     C     PAM02         IFNE      0
     C                   MOVE(P)   PAM02         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPAM02
     C                   ELSE
     C                   MOVE      *BLANKS       DPAM02
     C                   ENDIF
      *
     C     PAM03         IFNE      0
     C                   MOVE(P)   PAM03         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPAM03
     C                   ELSE
     C                   MOVE      *BLANKS       DPAM03
     C                   ENDIF
      *
     C     PAM04         IFNE      0
     C                   MOVE(P)   PAM04         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPAM04
     C                   ELSE
     C                   MOVE      *BLANKS       DPAM04
     C                   ENDIF
      *
     C     PAM05         IFNE      0
     C                   MOVE(P)   PAM05         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPAM05
     C                   ELSE
     C                   MOVE      *BLANKS       DPAM05
     C                   ENDIF
      *
     C     PAM06         IFNE      0
     C                   MOVE(P)   PAM06         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPAM06
     C                   ELSE
     C                   MOVE      *BLANKS       DPAM06
     C                   ENDIF
      *
     C     PAM07         IFNE      0
     C                   MOVE(P)   PAM07         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPAM07
     C                   ELSE
     C                   MOVE      *BLANKS       DPAM07
     C                   ENDIF
      *
     C     PAM08         IFNE      0
     C                   MOVE(P)   PAM08         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPAM08
     C                   ELSE
     C                   MOVE      *BLANKS       DPAM08
     C                   ENDIF
      *
     C     PAM09         IFNE      0
     C                   MOVE(P)   PAM09         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPAM09
     C                   ELSE
     C                   MOVE      *BLANKS       DPAM09
     C                   ENDIF
      *
     C     PAM10         IFNE      0
     C                   MOVE(P)   PAM10         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPAM10
     C                   ELSE
     C                   MOVE      *BLANKS       DPAM10
     C                   ENDIF
      *
     C     PAM11         IFNE      0
     C                   MOVE(P)   PAM11         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPAM11
     C                   ELSE
     C                   MOVE      *BLANKS       DPAM11
     C                   ENDIF
      *
     C     PAM12         IFNE      0
     C                   MOVE(P)   PAM12         ZFIELD
     C                   EXSR      CVTFLD
     C                   MOVE      ZFIELD        DPAM12
     C                   ELSE
     C                   MOVE      *BLANKS       DPAM12
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * CVTFLD - Convert a Numeric Field for Display                  *
      *                                                               *
      *****************************************************************
     C     CVTFLD        BEGSR
 
     C**********         CALLB     'ZEDIT'                                                  MD024886
     C**********         PARM                    ZFIELD           16                        MD024886
     C**********         PARM                    ZADEC             1 0                      MD024886
                                                                                            MD024886
     C                   MOVE      ZFIELD        P#Amtw                                     MD024886
                                                                                            MD024886
     C                   CALLB     'ZA0921'                                                 MD024886
     C                   PARM      *BLANK        P#Retc                                     MD024886
     C                   PARM                    P#Amtw                                     MD024886
     C                   PARM      ZADEC         P#Decp                                     MD024886
     C                   PARM                    BNDCSP            1                        MD024886
     C                   PARM                    P#Amtd                                     MD024886
     C                   PARM                    P#Amtp                                     MD024886
                                                                                            MD024886
     C                   MOVE      P#Amtd        ZFIELD           16                        MD024886
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * GETCCYDET - Get currency details                              *
      *****************************************************************
     C     GETCCYDET     BEGSR
 
      **  Access Currency Details
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR  '    PRTCD             7
     C                   PARM      '*KEY    '    POPTN             7
     C                   PARM                    @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   ENDSR
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * SRSETCNI - Reset Customer Details Counter                     *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     SRSETCNI      BEGSR                                                               CSF011A
                                                                                             CSF011A
      ** Initialise position counter for Settle and Pay                                      CSF011A
                                                                                             CSF011A
     C                   EVAL      CusIdxA = 57                                              CSF011A
     C                   EVAL      CusIdxB = 67                                              CSF011A
     C                   EVAL      CusIdxC = 87                                              CSF011A
     C                   EVAL      CusIdxD = 97                                              CSF011A
     C                   EVAL      CusIdxE = 117                                             CSF011A
     C                   EVAL      W@Len = 115                                               CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * SROURACT - Determine type of Account                          *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     SROURACT      BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   SETOFF                                       5051                   CSF011A
                                                                                             CSF011A
     C                   TESTN                   A#ACOD               50                     CSF011A
     C   50              TESTN                   A#ACSQ               50                     CSF011A
     C                   TESTN                   A#RENO               51                     CSF011A
                                                                                             CSF011A
      ** For General Ledger Accounts                                                         CSF011A
                                                                                             CSF011A
     C                                                                                       CSF011A
     C                   IF        *IN50 = *ON                                               CSF011A
     C                   MOVEL     *BLANKS       PACID                                       CSF011A
     C                   MOVEL     A#CNUM        PACID                                       CSF011A
     C                   MOVE      A#ACSQ        PACSN                                       CSF011A
     C                   MOVE      A#ACOD        PACCD                                       CSF011A
     C                   MOVE      A#BRCA        PBRCA                                       CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
      ** For Retail Accounts                                                                 CSF011A
                                                                                             CSF011A
     C                   IF        *IN51 = *ON AND A#REST = *BLANKS                          CSF011A
     C                   MOVEL     A#RENO        PACID                                       CSF011A
     C                   MOVE      *BLANKS       PCYCD                                       CSF011A
     C                   MOVE      *BLANKS       PACSN                                       CSF011A
     C                   MOVE      *BLANKS       PACCD                                       CSF011A
     C                   MOVE      *BLANKS       PBRCA                                       CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   EXSR      ACACCT                                                    CSF011A
                                                                                             CSF011A
     C                   IF        PRTCD = *BLANKS                                           CSF011A
     C                   EXSR      CSFACT                                                    CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * ACACCT - ACCESS ACCOUNT DETAILS                               *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     ACACCT        BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   CALL      'AOACCTV0'                                                CSF011A
     C                   PARM      *BLANKS       PRTCD                                       CSF011A
     C                   PARM                    PACID                                       CSF011A
     C                   PARM                    PCYCD                                       CSF011A
     C                   PARM                    PACCD                                       CSF011A
     C                   PARM                    PACSN                                       CSF011A
     C                   PARM                    PBRCA                                       CSF011A
     C                   PARM      *BLANKS       PTYPE                                       CSF011A
     C                   PARM      *BLANKS       PNOSN                                       CSF011A
     C     ACCT          PARM      ACCT          DSSDY                                       CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * ACCUST - ACCESS CUSTOMER DETAILS                              *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     ACCUST        BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   CALL      'AOCUSTR0'                                                CSF011A
     C                   PARM      *BLANKS       PRTCD                                       CSF011A
     C                   PARM      '*KEY   '     POPTN                                       CSF011A
     C                   PARM      CNUM          @CSCN                                       CSF011A
     C                   PARM      *BLANKS       @KYST                                       CSF011A
     C     SDCUST        PARM      SDCUST        DSSDY                                       CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * CSFACT - Populate Customer Name on Input fields               *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     CSFACT        BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   EXSR      ACCUST                                                    CSF011A
                                                                                             CSF011A
     C                   IF        PRTCD = *BLANKS                                           CSF011A
     C                   IF        SETTF = 'P'                                               CSF011A
     C                   EVAL      %SUBST(#FPAYS:CusIdxA:10) = C_BBCSSN                      CSF011A
     C                   EVAL      %SUBST(#FPAYS:CusIdxB:20) = C_BBCRNM                      CSF011A
     C                   EVAL      %SUBST(#FPAYS:CusIdxC:10) = C_BBCRTN                      CSF011A
     C                   EVAL      %SUBST(#FPAYS:CusIdxD:20) = ANAM                          CSF011A
     C                   EVAL      %SUBST(#FPAYS:CusIdxE:12) = C_BBCSID                      CSF011A
     C                   ELSEIF    SETTF = 'R'                                               CSF011A
     C                   EVAL      %SUBST(#FRECS:CusIdxA:10) = C_BBCSSN                      CSF011A
     C                   EVAL      %SUBST(#FRECS:CusIdxB:20) = C_BBCRNM                      CSF011A
     C                   EVAL      %SUBST(#FRECS:CusIdxC:10) = C_BBCRTN                      CSF011A
     C                   EVAL      %SUBST(#FRECS:CusIdxD:20) = ANAM                          CSF011A
     C                   EVAL      %SUBST(#FRECS:CusIdxE:12) = C_BBCSID                      CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   EVAL      CusIdxA = CusidxA + W@Len                                 CSF011A
     C                   EVAL      CusIdxB = CusidxB + W@Len                                 CSF011A
     C                   EVAL      CusIdxC = CusidxC + W@Len                                 CSF011A
     C                   EVAL      CusIdxD = CusidxD + W@Len                                 CSF011A
     C                   EVAL      CusIdxE = CusidxE + W@Len                                 CSF011A
     C                                                                                       CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * SRLOADR - Load Receipt Account Array                          *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     SRLOADR       BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   MOVE      DRAC01        WSRACT(1)                                   CSF011A
     C                   MOVE      DRAC02        WSRACT(2)                                   CSF011A
     C                   MOVE      DRAC03        WSRACT(3)                                   CSF011A
     C                   MOVE      DRAC04        WSRACT(4)                                   CSF011A
     C                   MOVE      DRAC05        WSRACT(5)                                   CSF011A
     C                   MOVE      DRAC06        WSRACT(6)                                   CSF011A
     C                   MOVE      DRAC07        WSRACT(7)                                   CSF011A
     C                   MOVE      DRAC08        WSRACT(8)                                   CSF011A
     C                   MOVE      DRAC09        WSRACT(9)                                   CSF011A
     C                   MOVE      DRAC10        WSRACT(10)                                  CSF011A
     C                   MOVE      DRAC11        WSRACT(11)                                  CSF011A
     C                   MOVE      DRAC12        WSRACT(12)                                  CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * SRLOADP - Load Payment Account Array                          *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     SRLOADP       BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   MOVE      DPAC01        WSPACT(1)                                   CSF011A
     C                   MOVE      DPAC02        WSPACT(2)                                   CSF011A
     C                   MOVE      DPAC03        WSPACT(3)                                   CSF011A
     C                   MOVE      DPAC04        WSPACT(4)                                   CSF011A
     C                   MOVE      DPAC05        WSPACT(5)                                   CSF011A
     C                   MOVE      DPAC06        WSPACT(6)                                   CSF011A
     C                   MOVE      DPAC07        WSPACT(7)                                   CSF011A
     C                   MOVE      DPAC08        WSPACT(8)                                   CSF011A
     C                   MOVE      DPAC09        WSPACT(9)                                   CSF011A
     C                   MOVE      DPAC10        WSPACT(10)                                  CSF011A
     C                   MOVE      DPAC11        WSPACT(11)                                  CSF011A
     C                   MOVE      DPAC12        WSPACT(12)                                  CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT
      *****************************************************************
      *                                                               *
      * INITSC - INITIALIZE ALL SCREEN INSTRUCTIONS                   *
      *                                                               *
      *****************************************************************
     C     INITSC        BEGSR
 
      ** Get Receipt currency details
 
     C                   MOVEL     ##RCCY        @CURR
     C                   EXSR      GETCCYDET
     C                   Z-ADD     A6NBDP        RNBDP             1 0
 
      ** Get Payment currency details
 
     C                   MOVEL     ##PCCY        @CURR
     C                   EXSR      GETCCYDET
     C                   Z-ADD     A6NBDP        PNBDP             1 0
                                                                                             CSF011A
     C                   CLEAR                   WSRACT                                      CSF011A
     C                   CLEAR                   WSPACT                                      CSF011A
                                                                                            MD024886
      ** Access Dealing details via access program                                          MD024886
                                                                                            MD024886
     C                   CALLB     'AODEALR0'                                               MD024886
     C                   PARM      '*DBERR '     PRTCD                                      MD024886
     C                   PARM      '*FIRST '     POPTN                                      MD024886
     C     SDDEAL        PARM      SDDEAL        DSFDY                                      MD024886
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** Deal Number
     C                   PARM                    ##DLNO            6
      *
      ** Action Code
     C                   PARM                    ##ACTN            1
      *
      ** Payment currency
     C                   PARM                    ##PCCY            3
      *
      ** Receive currency
     C                   PARM                    ##RCCY            3
      *
      ** LDNI Deal details
     C                   PARM                    NwDlFilFmt
      *
      ** OUTPUT
      *
      ** Screen - Payment Further Settlement Instructions
     C                   PARM                    #FPAYS
      *
      ** Screen - Receive Further Settlement Instructions
     C                   PARM                    #FRECS
 
 
      ** Determine Deal Type
 
     C     ##ACTN        IFEQ      'I'
     C                   MOVE      IKTYPE        DLTYPE            2
     C                   ELSE
     C                   MOVE      IKMTYP        DLTYPE
     C                   ENDIF
 
      ** Calculate Total of Principal + Interest of Deal
 
     C     IKAMNP        IFLT      0
     C                   Z-SUB     IKAMNP        UAMNP            15 0
     C                   ELSE
     C                   Z-ADD     IKAMNP        UAMNP
     C                   ENDIF
      *
     C     IKMTTI        IFLT      0
     C                   Z-SUB     IKMTTI        UMTTI            15 0
     C                   ELSE
     C                   Z-ADD     IKMTTI        UMTTI
     C                   ENDIF
      *
     C     UAMNP         ADD       UMTTI         TotAmIn          15 0
     C                   MOVE      TotAmIn       PAmtInRec        16
     C                   MOVE      TotAmIn       PAmtInPay        16
      *
      ** If 'Interest Paid Seperately' is set to 'Y' only Principal is allowed
      ** If 'Front up Interest' is set to 'Y' only Principal is allowed
      *
     C                   IF        IKIPDS = 'Y' OR IKFUID = 'Y'
     C                   MOVE      UAMNP         PAmtInRec
     C                   MOVE      UAMNP         PAmtInPay
     C                   ENDIF
 
     C                   ENDSR
