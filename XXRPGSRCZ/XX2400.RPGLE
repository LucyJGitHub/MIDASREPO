     H DEBUG
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2020')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SE Gen a/c keys posn settles CAR program')       *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
*********SE2400V0*-*Midas*SE*Gen*a/c*keys*posn*settles*CAR*program*****                  HUT103
      *  XX2400   - Midas SE Gen a/c keys posn settles CAR program    *                  HUT103
      *                                                               *
      *  Function:  This program performs non-Core processing for     *
      *             SE2400.                                           *
      *                                                               *
      *  Called By: SE2400 Via*WN0100                                 *
      *                                                               *
      ***(c)*Misys*International*Banking Systems*Ltd.*2007*************                  HUT103
      *  (c) Finastra International Systems Ltd. 2020                 *                  HUT103
      *                                                               *
      *  Last Amend No. HUT103             Date 03Apr20               *
      *  Prev Amend No. MD042648           Date 19Apr17               *
      *                 256587A            Date 07Apr09               *
      *                 256587             Date 12Feb09               *
      *                 AUA012             Date 28Nov08               *
      *                 HUT009I01          Date 11Mar08               *
      *                 HUT009C01          Date 28Feb08               *
      *                 HUT009             Date 18Jan08               *
      *                 HUT003  *CREATE    Date 21Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT103 - Position Settlement Account Defaulting              *
      *           Upgrade HUT009 to FM2.1 SP22                        *
      *  MD042648 - Incorrect settlement branch for the position      *
      *             settlement record.  Always pass branch code.      *
      *  256587A - Reversed fix 256587.                               *
      *  256587 - Verify if currency is the same when computing the   *
      *           tax amount deducted by user.                        *
      *  AUA012 - Include SE Country of Risk in HUT003                *
      *  HUT009I01 - SFDC 243066 Incorrect settlement acct defaulted  *
      *  HUT009C01 - SFDC 240653 Off-spec fix; Check for open/close   *
      *              account instead of active/inactive               *
      *  HUT009 - Position Settlement Account Defaulting              *
      *  HUT003 - Withholding Tax Enhancement                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDWTRCL1  IF   E           K DISK
     FSECTY     IF   E           K DISK
      */OMITSTART                                                                        HUT103
     FPOSETDX9  O    E             DISK
     FPOSETDXX9 O    E             DISK
      */OMITEND                                                                          HUT103
     F**********SEPOACV0  IF   E           K DISK                                      HUT009 HUT103
     FXXPOACL0  IF   E           K DISK                                                       HUT103
     FPMACCNL0  IF   E           K DISK                                                       HUT009

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

     D RUNDAT        E DS                  EXTNAME(RUNDAT)

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External Data Structure - SAR details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External Data Structure - Customer details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External Data Structure - Currency details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access programs

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access programs
                                                                                              HUT009
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     HUT009
      ** Data structure for access program, extra long data structure                         HUT009

     D ACCNTDS       E DS                  EXTNAME(ACCNTAB)                                   HUT009
     D  @LCD         E                     EXTFLD(LCD)                                        HUT009
     D  @RECI        E                     EXTFLD(RECI)                                       HUT009
      ** External Data Structure - Account details                                            HUT009

     D DATA2           DS          1024
     D  UPSEQ                  1      5
     D**DPCPY***               6     11  0                                                    HUT103
     D  DPCPY                  6     11                                                       HUT103
     D  DPSSH                 12     21
     D  DSDET                 22     23
     D  DPBCA                 24     26
     D  DPNCY                 27     29
     D  DPAMD                 30     42  0
     D  DPSVL                 43     47  0
     D  DPEVT                 48     49
     D  DUTXRU                50     56  4
     D  DTAUS                 57     69  0
     D  DPBCD                 70     71
     D  DIN80W                72     72
     D  DCNUM                 73     78                                                       HUT009
     D  DPTFR                 79     82                                                       HUT009
     D  DBRCD                 83     85                                                       HUT009
     D  DCCY                  86     88                                                       HUT009
     D  DFOND                 89     89                                                       HUT009
     D  DSETA                 90    107                                                       HUT009

     D DATAI           DS            99
     D  DIN80                 80     80

     D DATAF1          DS          5000
     D DATAF2          DS          5000
     D DATAF3          DS          5000
     D DATAF4          DS          5000

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      /COPY ZACPYSRC,PSDS
      ** Program Status Data Structure

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

     D @RUN            S              1
     D @RTCD           S              7
     D @OPTN           S              7
     D @SARD           S              6
     D HUT003          S              1
     D ACTION          S              1
     D RETURN          S              7
     D HUT009          S              1                                                       HUT009
     D HUT103          S              1                                                       HUT103

     D ACCCY           S                   LIKE(GCCY)                                         HUT009
     D*ACCNUM***       S              6S 0                                                    HUT009
     D ACCNUM          S              6                                                       HUT103
     D ACPTFR          S                   LIKE(GPTFR)                                        HUT009
     D PABRCA          S                   LIKE(GBRCA)                                        HUT009
     D PACCY           S                   LIKE(GCCY)                                         HUT009
     D PAPTFR          S                   LIKE(GPTFR)                                        HUT009
     D PAPEVT          S                   LIKE(GSDET)                                        HUT009

     D WFound          S              1                                                       HUT009
     D WLeave          S              1                                                       HUT009

     D K_ALL           S              3    Inz('ALL')                                         HUT009
     D K_BLANK         S              2    Inz(*Blanks)                                       HUT009
     D P@ACSQ          S              2                                                       HUT009
     D ACSQWRK         S              2                                                       HUT009
     D GCSQWRK         S              2                                                       HUT009
     D ACODWRK         S             10                                                       HUT009
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Read in Installation Data

     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT

     C                   SELECT
     C     UPSEQ         WHENEQ    '00001'
     C     HUT003        IFEQ      'Y'
     C*****DIN80         ANDEQ     '0'
     C                   EXSR      SR00001
     C                   ENDIF

     C     UPSEQ         WHENEQ    '00002'
     C     HUT003        IFEQ      'Y'
     C*******************MOVE      DIN80         DIN80W
     C*******************MOVE      '1'           DIN80
     C                   MOVE      '0'           DIN80
     C                   ENDIF

     C     UPSEQ         WHENEQ    '00003'
     C     HUT003        IFEQ      'Y'
     C     DIN80         ANDEQ     '1'
     C                   MOVEL     'GOTOTAG'     RETURN
     C                   ENDIF

     C     UPSEQ         WHENEQ    '00004'                                                    HUT009
     C*****HUT009        IFEQ      'Y'                                                 HUT009 HUT103
     C     HUT103        IFEQ      'Y'                                                        HUT103
     C                   EXSR      SR00004                                                    HUT009
     C                   ENDIF                                                                HUT009
     C                   ENDSL

     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR00001 - Processing subroutine for User Process 00001       *
      *            Calculate Withholding Tax                          *
      *                                                               *
      *****************************************************************

     C     SR00001       BEGSR
      */OMITSTART                                                                        HUT103
     C                   MOVEL     DPCPY         @CNUM

      ** Get country of  domicile, customer type, and institution code

     C                   CALL      'AOCUSTR0'
     C                   PARM                    @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY

      ** Get transaction subtype

     C     DPSSH         CHAIN     SECTY                              79
     C     *IN79         IFNE      '1'
     C     RECI          COMP      '*'                                    79
     C                   END
     C     *IN79         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SECTY'       DBFILE
     C                   MOVEL     DPSSH         DBKEY
     C                   SETON                                        U7U8
     C                   Z-ADD     01            DBASE
     C                   DUMP
     C                   MOVE      '*ERROR'      RETURN
     C                   SETON                                        LR
     C                   RETURN
                                                                                              AUA012
     C                   ELSE                                                                 AUA012
      * Move countr of risk value from SECTY to work variable                                 AUA012
     C     AUA012        IFEQ      'Y'                                                        AUA012
     C                   MOVEL     SCOR          @CTRK                                        AUA012
     C                   ELSE                                                                 AUA012
     C                   MOVE      *BLANKS       @CTRK                                        AUA012
     C                   ENDIF                                                                AUA012
     C                   END

      ** Default payment a tax rate code

     C     DSDET         IFEQ      'DV'
     C                   MOVEL     'D '          PSTP
     C                   ELSE
     C                   MOVEL     'I '          PSTP
     C                   ENDIF

     C                   MOVEL     SITP          PRTP

     C                   CALL      'AOWTDFR0'
     C                   PARM                    @RRTCD            1
     C                   PARM      DPBCA         BRCD              3
     C                   PARM      *BLANK        BOOK              2
     C                   PARM      DPNCY         CCY               3
     C                   PARM      BBCOLC        CDOC              2
     C                   PARM      BBCSTY        CTYP              1
     C                   PARM      BBLINC        INST              2
     C                   PARM      'SE'          MODU              2
     C                   PARM                    PRTP             10
     C                   PARM                    PSTP              2
     C                   PARM                    @WTRC             2
      * Pass Country of Risk                                                                  AUA012
     C                   PARM                    @CTRK             2                          AUA012

      ** No Valid Withholding Tax Rate Code found

     C     @RRTCD        IFNE      '0'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF

      ** Retrieve rate code detail from SDWTRCPD

     C     @WTRC         CHAIN     SDWTRCD2                           50
     C     *IN50         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDWTRCL1'    DBFILE
     C                   MOVEL     @WTRC         DBKEY
     C                   Z-ADD     02            DBASE
     C                   SETON                                          U7U8
     C                   MOVE      '*ERROR'      RETURN
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF

     C                   CALL      'AOCURRR0'
     C                   PARM                    @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      CYCD          @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY

      ** From values

     C                   MOVEL     CYCD          ZCCYF
     C                   Z-ADD     MINT          ZAMTF
     C                   Z-ADD     A6SPRT        ZRATEF
     C                   MOVEL     A6MDIN        ZMDINF
     C                   Z-ADD     A6NBDP        ZCDPF

     C                   CALL      'AOCURRR0'
     C                   PARM                    @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DPNCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY

      ** To values

     C                   MOVEL     DPNCY         ZCCYT
     C                   Z-ADD     0             ZAMTT
     C                   Z-ADD     A6SPRT        ZRATET
     C                   MOVEL     A6MDIN        ZMDINT
     C                   Z-ADD     A6NBDP        ZCDPT

     C                   CALL      'ZCCYCN1'
     C                   PARM                    ZAMTF            15 0
     C                   PARM                    ZCCYF             3
     C                   PARM                    ZCCYT             3
     C                   PARM                    ZRATEF           13 8
     C                   PARM                    ZRATET           13 8
     C                   PARM                    ZMDINF            1
     C                   PARM                    ZMDINT            1
     C                   PARM                    ZCDPF             1 0
     C                   PARM                    ZCDPT             1 0
     C                   PARM                    ZAMTT            15 0
     C                   PARM                    ZCRSRT           13 8
     C                   PARM                    ZCRSMD            1

      ** Retrieve Coupon/Dividend

     C                   MOVE      DPAMD         WUZASF           16

      ** ZEDIT Screen Field - Standard Functions  *

     C                   CALL      'ZEDIT'                              90
     C     WUZASF        PARM      WUZASF        WQ0029           16
     C                   PARM      A6NBDP        WQ0030            1 0
     C                   MOVEL     WUZASF        AMT              15

      ** If minimum balance > dividend/coupon amount then set up
      ** tax amount as 0
      ***Or*FROM*currency*is*different*from*TO*currency****************               256587 256587A

     C     ZAMTT         IFGT      DPAMD
     C     @RRTCD        ORNE      '0'
     C*****CYCD*         ORNE      DPNCY                                              256587 256587A
     C                   Z-ADD     0             DUTXRU
     C                   Z-ADD     0             DTAUS
     C                   SETON                                        LR
     C                   RETURN

     C                   ELSE
     C     DIN80         IFEQ      '1'
     C                   MOVE      DPCPY         HPCPY
     C                   MOVE      DPSSH         HPSSH
     C                   MOVE      DPBCA         HPBCA
     C                   MOVE      DPBCD         HPBCD
     C                   MOVE      DPNCY         HPNCY
     C                   MOVE      AMT           HAMT
     C                   WRITE     POSETXXD
     C                   Z-ADD     0             DUTXRU
     C                   Z-ADD     0             DTAUS
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF

      ** Write position settlement extension file

     C                   MOVE      DPBCA         BRCH
     C                   Z-ADD     DPSVL         DUED
     C                   MOVEL     DPSSH         SECN
     C                   MOVE      DPCPY         CUNO
     C                   MOVE      DPEVT         EVEN
     C                   Z-ADD     DPAMD         INTA
     C                   Z-ADD     WTRT          WHTR
     C                   MOVE      @WTRC         WHRC
     C                   WRITE     POSETDD9
     C                   Z-ADD     WTRT          DUTXRU

     C     DUTXRU        DIV       100           URATE             5 4
     C     DPAMD         MULT      URATE         DTAUS
     C                   SETON                                        LR
     C                   RETURN

     C                   ENDIF
      */OMITEND                                                                          HUT103

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR00004 - Default settlement account                         *
      *                                                               *
      *****************************************************************
     C     SR00004       BEGSR                                                                HUT009
      *                                                                                       HUT009
     C     DFOND         IFEQ      'Y'                                                        HUT009
     C     DBRCD         ANDNE     *Blanks                                                    HUT009
     C                   MOVEL     DBRCD         PABRCA                                       HUT009
     C                   ELSE                                                                 HUT009
     C                   CALL      'AOCUSTR1'                                                 HUT009
     C                   PARM      *BLANKS       P@RTCD            7                          HUT009
     C                   PARM      '*KEY    '    P@OPTN            7                          HUT009
     C                   PARM      DCNUM         P@CSCN           10                          HUT009
     C                   PARM      *BLANKS       P@KYST            7                          HUT009
     C     SDCUST        PARM      SDCUST        DSLDY                                        HUT009
      *                                                                                       HUT009
     C                   MOVEL     BBBRCD        PABRCA                                       HUT009
     C                   ENDIF                                                                HUT009
      *                                                                                       HUT009
     C                   MOVEL     DPTFR         PAPTFR                                       HUT009
     C                   MOVEL     DCCY          PACCY                                        HUT009
     C                   MOVEL     DPEVT         PAPEVT                                       HUT009
     C                   MOVE      'N'           WLeave                                       HUT009
     C                   MOVE      'N'           WFound                                       HUT009
     ** Access Portfolio Account file                                                         HUT009
      *                                                                                       HUT009
     C*****KPOAC1        CHAIN     SEPOACV0                                            HUT009 HUT103
     C**********         IF        %FOUND(SEPOACV0)                                    HUT009 HUT103
     C     KPOAC1        CHAIN     XXPOACL0                                                   HUT103
     C                   IF        %FOUND(XXPOACL0)                                           HUT103
     C                   MOVE      'Y'           WLeave                                       HUT009
     C                   ENDIF                                                                HUT009
      *                                                                                       HUT009
     C     WLeave        IFEQ      'N'                                                        HUT009
     C*****KPOAC2        CHAIN     SEPOACV0                                            HUT009 HUT103
     C**********         IF        %FOUND(SEPOACV0)                                    HUT009 HUT103
     C     KPOAC2        CHAIN     XXPOACL0                                                   HUT103
     C                   IF        %FOUND(XXPOACL0)                                           HUT103
     C                   MOVE      'Y'           WLeave                                       HUT009
     C                   ENDIF                                                                HUT009
     C                   ENDIF                                                                HUT009
      *                                                                                       HUT009
     C     WLeave        IFEQ      'N'                                                        HUT009
     C*****KPOAC3        CHAIN     SEPOACV0                                            HUT009 HUT103
     C**********         IF        %FOUND(SEPOACV0)                                    HUT009 HUT103
     C     KPOAC3        CHAIN     XXPOACL0                                                   HUT103
     C                   IF        %FOUND(XXPOACL0)                                           HUT103
     C                   MOVE      'Y'           WLeave                                       HUT009
     C                   ENDIF                                                                HUT009
     C                   ENDIF                                                                HUT009
      *                                                                                       HUT009
     C     WLeave        IFEQ      'N'                                                        HUT009
     C*****KPOAC4        CHAIN     SEPOACV0                                            HUT009 HUT103
     C**********         IF        %FOUND(SEPOACV0)                                    HUT009 HUT103
     C     KPOAC4        CHAIN     XXPOACL0                                                   HUT103
     C                   IF        %FOUND(XXPOACL0)                                           HUT103
     C                   MOVE      'Y'           WLeave                                       HUT009
     C                   ENDIF                                                                HUT009
     C                   ENDIF                                                                HUT009
      *                                                                                       HUT009
     C     WLeave        IFEQ      'N'                                                        HUT009
     C*****KPOAC5        CHAIN     SEPOACV0                                            HUT009 HUT103
     C**********         IF        %FOUND(SEPOACV0)                                    HUT009 HUT103
     C     KPOAC5        CHAIN     XXPOACL0                                                   HUT103
     C                   IF        %FOUND(XXPOACL0)                                           HUT103
     C                   MOVE      'Y'           WLeave                                       HUT009
     C                   ENDIF                                                                HUT009
     C                   ENDIF                                                                HUT009
      *                                                                                       HUT009
     C     WLeave        IFEQ      'N'                                                        HUT009
     C*****KPOAC6        CHAIN     SEPOACV0                                            HUT009 HUT103
     C*********          IF        %FOUND(SEPOACV0)                                    HUT009 HUT103
     C     KPOAC6        CHAIN     XXPOACL0                                                   HUT103
     C                   IF        %FOUND(XXPOACL0)                                           HUT103
     C                   MOVE      'Y'           WLeave                                       HUT009
     C                   ENDIF                                                                HUT009
     C                   ENDIF                                                                HUT009
      *                                                                                       HUT009
     C     WLeave        IFEQ      'N'                                                        HUT009
     C*****KPOAC7        CHAIN     SEPOACV0                                            HUT009 HUT103
     C**********         IF        %FOUND(SEPOACV0)                                    HUT009 HUT103
     C     KPOAC7        CHAIN     XXPOACL0                                                   HUT103
     C                   IF        %FOUND(XXPOACL0)                                           HUT103
     C                   MOVE      'Y'           WLeave                                       HUT009
     C                   ENDIF                                                                HUT009
     C                   ENDIF                                                                HUT009
      *                                                                                       HUT009
     C     WLeave        IFEQ      'N'                                                        HUT009
     C*****KPOAC8        CHAIN     SEPOACV0                                            HUT009 HUT103
     C**********         IF        %FOUND(SEPOACV0)                                    HUT009 HUT103
     C     KPOAC8        CHAIN     XXPOACL0                                                   HUT103
     C                   IF        %FOUND(XXPOACL0)                                           HUT103
     C                   MOVE      'Y'           WLeave                                       HUT009
     C                   ENDIF                                                                HUT009
     C                   ENDIF                                                                HUT009
      *                                                                                       HUT009
     C     WLeave        IFEQ      'Y'                                                        HUT009
      *                                                                                       HUT009
     C                   Move      GACSQ         P@ACSQ
     C                   CALL      'AOACCTR0'                                                 HUT009
     C                   PARM      *Blanks       P@RTCD                                       HUT009
     C                   PARM      '*KEY'        P@OPTN                                       HUT009
     C                   PARM      *BLANKS       P@RETL           10                          HUT009
     C                   PARM      DCNUM         P@CNUM            6                          HUT009
     C                   PARM      DCCY          P@CUCD            3                          HUT009
     C                   PARM      GACOD         P@ACCD           10                          HUT009
     C                   PARM                    P@ACSQ                                       HUT009
     C                   PARM      PABRCA        P@BRCA            3                          HUT009
     C     ACCNTDS       PARM      ACCNTDS       DSLDY                                        HUT009
      *                                                                                       HUT009
     C                   If        P@RTCD = *Blanks And @RECI = 'D'                           HUT009
     C                             And ACST <> 'C'                                         HUT009C01
     ***If*found,*check*if*active*                                                  HUT009 HUT009C01
      **********                                                                    HUT009 HUT009C01
     C**********         TESTB     '4'           RETB                 80            HUT009 HUT009C01
     C******IN80         IFEQ      *ON                                              HUT009 HUT009C01
                                                                                           HUT009C01
     ** Set settlement field if an open account is found                                   HUT009C01
                                                                                           HUT009C01
     C                   MOVE      'Y'           WFound                                       HUT009
     C                   MOVE      *BLANKS       WSETA            18                          HUT009
     C                   MOVE      GACSQ         GCSQWRK
     C                   EVAL      WSETA = DCNUM + %Trim(GACOD) +                             HUT009
     C                               GCSQWRK                                                  HUT009
     C                   EVAL      DBRCD = BRCA                                             MD042648
     C**********         ENDIF                                                      HUT009 HUT009C01
      *                                                                                       HUT009
     C                   ENDIF                                                                HUT009
      * If account found is closed, get next open account for                              HUT009I01
      * cust-ccy-portfolio combination                                                     HUT009I01
     C     WFound        IFEQ      'N'                                                     HUT009I01
     C                   MOVE      DCNUM         ACCNUM                                    HUT009I01
     C                   MOVE      DCCY          ACCCY                                     HUT009I01
     C                   MOVEL     GACSQ         WRK1              1 0                     HUT009I01
     C                   Z-ADD     WRK1          WPTFR             4 0                     HUT009I01
     C                   MOVE      WPTFR         ACPTFR                                    HUT009I01
      *                                                                                    HUT009I01
     C     KACCN         SETLL     PMACCNL0                                                HUT009I01
     C     KACCN         READE     PMACCNL0                                                HUT009I01
     C                   DOW       WFound = 'N' and Not %EOF(PMACCNL0)                     HUT009I01
     C                   IF        ACST <> 'C'                                             HUT009I01
     C                   MOVE      'Y'           WFound                                    HUT009I01
     C                   MOVE      *BLANKS       WSETA            18                       HUT009I01
     C                   MOVE      ACSQ          ACSQWRK                                   HUT009I01
     C                   MOVE      ACOD          ACODWRK                                   HUT009I01
     C                   EVAL      WSETA = DCNUM + ACODWRK  +                              HUT009I01
     C                             ACSQWRK                                                 HUT009I01
     C                   EVAL      DBRCD = BRCA                                             MD042648
     C                   ENDIF                                                             HUT009I01
     C     KACCN         READE     PMACCNL0                                                HUT009I01
     C                   ENDDO                                                             HUT009I01
     C                   ENDIF                                                             HUT009I01
      *                                                                                       HUT009
     C                   ENDIF                                                                HUT009
      *                                                                                       HUT009
      **If*no*active*account*found*yet,*get*active*account*for*                     HUT009 HUT009C01
      * If no open account found yet, get next open account for                            HUT009C01
      * cust-ccy-portfolio combination                                                        HUT009
     C     WFound        IFEQ      'N'                                                        HUT009
     C                   MOVE      DCNUM         ACCNUM                                       HUT009
     C                   MOVE      DCCY          ACCCY                                        HUT009
     C                   MOVE      DPTFR         ACPTFR                                       HUT009
      *                                                                                       HUT009
     C     KACCN         SETLL     ACCNTABF                                                   HUT009
     C     KACCN         READE     PMACCNL0                                                   HUT009
     C                   DOW       WFound = 'N' and Not %EOF(PMACCNL0)                        HUT009
     C**********         TESTB     '4'           RETB                 80            HUT009 HUT009C01
     C******IN80         IFEQ      *ON                                              HUT009 HUT009C01
     C                   IF        ACST <> 'C'                                             HUT009C01
     C                   MOVE      'Y'           WFound                                       HUT009
     C                   MOVE      *BLANKS       WSETA            18                          HUT009
     C                   MOVE      ACSQ          ACSQWRK
     C                   MOVE      ACOD          ACODWRK
     C                   EVAL      WSETA = DCNUM + ACODWRK +                                  HUT009
     C                             ACSQWRK                                                    HUT009
     C                   ENDIF                                                                HUT009
     C     KACCN         READE     PMACCNL0                                                   HUT009
     C                   ENDDO                                                                HUT009
     C                   ENDIF                                                                HUT009
      *                                                                                       HUT009
     C     WFound        IFEQ      'Y'                                                        HUT009
     C                   MOVE      'Y'           DFOND                                        HUT009
     C                   MOVE      WSETA         DSETA                                        HUT009
     C                   ELSE                                                                 HUT009
     C                   MOVE      'N'           DFOND                                        HUT009
     C                   MOVE      *BLANKS       DSETA                                        HUT009
     C                   ENDIF                                                                HUT009
      *                                                                                       HUT009
     C                   ENDSR                                                                HUT009
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    ACTION
     C                   PARM                    DATA2
     C                   PARM                    DATAI
     C                   PARM                    DATAF1
     C                   PARM                    DATAF2
     C                   PARM                    DATAF3
     C                   PARM                    DATAF4
     C                   PARM                    RETURN

      ** Check switchable feature HUT003

     C                   Call      'AOSARDR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*VERIFY'     @Optn
     C                   Parm      'HUT003'      @Sard
     C     SCSARD        Parm      SCSARD        DSFDY

     C                   If        @Rtcd = *Blanks
     C                   Move      'Y'           HUT003
     C                   Else
     C                   Move      'N'           HUT003
     C                   Endif

      ***Check*if*HUT009*is*switched*on                                                       HUT103
      ** Check if HUT103 is switched on                                                       HUT103
      *
     C                   Call      'AOSARDR0'                                                 HUT009
     C                   Parm      *Blanks       @Rtcd                                        HUT009
     C                   Parm      '*VERIFY'     @Optn                                        HUT009
     C**********         Parm      'HUT009'      @Sard                                 HUT009 HUT103
     C                   Parm      'HUT103'      @Sard                                        HUT103
     C     SCSARD        Parm      SCSARD        DSFDY                                        HUT009
                                                                                              HUT009
     C                   If        @Rtcd = *Blanks                                            HUT009
     C**********         Move      'Y'           HUT009                                HUT009 HUT103
     C                   Move      'Y'           HUT103                                       HUT103
     C                   Else                                                                 HUT009
     C**********         Move      'N'           HUT009                                HUT009 HUT103
     C                   Move      'N'           HUT103                                       HUT103
     C                   Endif                                                                HUT009
      *                                                                                       HUT009
     C     KPOAC1        KLIST                                                                HUT009
     C                   KFLD                    PAPTFR                                       HUT009
     C                   KFLD                    PABRCA                                       HUT009
     C                   KFLD                    PACCY                                        HUT009
     C                   KFLD                    PAPEVT                                       HUT009
      *                                                                                       HUT009
     C     KPOAC2        KLIST                                                                HUT009
     C                   KFLD                    PAPTFR                                       HUT009
     C                   KFLD                    PABRCA                                       HUT009
     C                   KFLD                    PACCY                                        HUT009
     C                   KFLD                    K_BLANK                                      HUT009
      *
     C     KPOAC3        KLIST                                                                HUT009
     C                   KFLD                    PAPTFR                                       HUT009
     C                   KFLD                    K_ALL                                        HUT009
     C                   KFLD                    PACCY                                        HUT009
     C                   KFLD                    PAPEVT                                       HUT009
      *                                                                                       HUT009
     C     KPOAC4        KLIST                                                                HUT009
     C                   KFLD                    PAPTFR                                       HUT009
     C                   KFLD                    K_ALL                                        HUT009
     C                   KFLD                    PACCY                                        HUT009
     C                   KFLD                    K_BLANK                                      HUT009
      *
     C     KPOAC5        KLIST                                                                HUT009
     C                   KFLD                    PAPTFR                                       HUT009
     C                   KFLD                    PABRCA                                       HUT009
     C                   KFLD                    K_ALL                                        HUT009
     C                   KFLD                    PAPEVT                                       HUT009
      *                                                                                       HUT009
     C     KPOAC6        KLIST                                                                HUT009
     C                   KFLD                    PAPTFR                                       HUT009
     C                   KFLD                    PABRCA                                       HUT009
     C                   KFLD                    K_ALL                                        HUT009
     C                   KFLD                    K_BLANK                                      HUT009
      *
     C     KPOAC7        KLIST                                                                HUT009
     C                   KFLD                    PAPTFR                                       HUT009
     C                   KFLD                    K_ALL                                        HUT009
     C                   KFLD                    K_ALL                                        HUT009
     C                   KFLD                    PAPEVT                                       HUT009
      *                                                                                       HUT009
     C     KPOAC8        KLIST                                                                HUT009
     C                   KFLD                    PAPTFR                                       HUT009
     C                   KFLD                    K_ALL                                        HUT009
     C                   KFLD                    K_ALL                                        HUT009
     C                   KFLD                    K_BLANK                                      HUT009
      *
     C     KACCN         KLIST                                                                HUT009
     C                   KFLD                    ACCNUM                                       HUT009
     C                   KFLD                    ACCCY                                        HUT009
     C                   KFLD                    ACPTFR                                       HUT009
      *
                                                                                              AUA012
      ** Check switchable feature AUA012                                                      AUA012
                                                                                              AUA012
     C                   Call      'AOSARDR0'                                                 AUA012
     C                   Parm      *Blanks       @Rtcd             7                          AUA012
     C                   Parm      '*VERIFY'     @Optn             7                          AUA012
     C                   Parm      'AUA012'      @Sard             6                          AUA012
     C     SCSARD        Parm      SCSARD        DSFDY                                        AUA012
                                                                                              AUA012
     C                   If        @Rtcd = *Blanks                                            AUA012
     C                   Move      'Y'           AUA012            1                          AUA012
     C                   Else                                                                 AUA012
     C                   Move      'N'           AUA012                                       AUA012
     C                   Endif                                                                AUA012
                                                                                              AUA012
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP

     C                   CALL      'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      RETURN = '*ERROR '
     C                   RETURN

     C                   ENDSR

