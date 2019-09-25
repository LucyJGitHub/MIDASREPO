     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GO Check valid / invalid API transactions')      *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO000136 - Midas GO Check valid / invalid API transactions   *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 MD020167           Date 23Apr13               *
      *                 CCB023  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  MD020167 - New fields DCUATH not available in LFs (Recompile)*
      *  CCB023 - COB Restructure - Input Cycle Termination           *
      *           Restructuring                                       *
      *                                                               *
      *****************************************************************

     FAPVTRANL0 IF   E           K DISK    INFSR(*PSSR)
     FAPVTRANL1 IF   E           K DISK    INFSR(*PSSR)

     FAPITRANL0 IF   E           K DISK    INFSR(*PSSR)
     FAPITRANL1 IF   E           K DISK    INFSR(*PSSR)

     FGPDWNLL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN

     D                 DS
     D  CountN                 1      5  0
     D  CountA                 1      5

      ** SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** Short data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** Midas Local Data Area for database error reporting
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc

      ** Declared Variables
     D CAP002          S              1A   INZ('N')
     D @RUN            S              1
     D Value           S             50

      ** Rename fields with common names that have different attributes
     IMMILDNID0
     I              DDAMNP                      @@AMNP
     I              DDSPRT                      @@SPRT
     I              DDLQPR                      @@LQPR
     I              DDISDT                      @@ISDT

     IMMINASPD0
     I              DDLQPR                      P@LQPR

     ISEIDPMVD0
     I              DDOPIN                      @@OPIN

     ISEITRADD0
     I              DDLQPR                      T@LQPR

     ISEIBYSLD0
     I              DDLQPR                      Y@LQPR

     IMMINASSD0
     I              DDBRKG                      @@BRKG

     IFTIIPAYD0
     I              DDPREF                      @@PREF
     I              DDRATE                      @@RATE
     I              DDNWRK                      @@NWRK

     ISDISECDD0
     I              DDADCD                      @@ADCD
     I              DDTXCD                      @@TXCD
     I              DDCLAS                      @@CLAS

     IABIFUNDD0
     I              #1AMNP                      @@PAMN
     I              #1TOTI                      @@TOTI

     ISEISECSD0
     I              DDBR01                      @@BR01
     I              DDBR02                      @@BR02
     I              DDBR03                      @@BR03
     I              DDBR04                      @@BR04
     I              DDBR05                      @@BR05
     I              DDBR06                      @@BR06
     I              DDBR07                      @@BR07
     I              DDBR08                      @@BR08
     I              DDBR09                      @@BR09
     I              DDBR10                      @@BR10

     IMMIRPLDD0
     I              DDAMNP                      @@AMNP2
     I              DDSPRT                      @@SPRT2
     I              DDTRTP                      @@TRTP

     ISEIMVTSD0
     I              DDNARR                      MVTS_NARR

     ISEITRSMD0
     I              DDTDFA                      TRSM_TDFA
     I              DDSREF                      TRSM_SREF

     ISEISTPRD0
     I              DDCUST                      STPR_CUST

     ILEICLIPD0
     I              DDPTFN                      @APTFN
     I              DDPTFT                      @APTFT
     I              DDRAMT                      @ARAMT
     I              DDCRSK                      @ACRSK

     ILEIFCIPD0
     I              DDCRSK                      FCCRSK

     ILEILOAMD0
     I              DDBRAT                      @BBRAT

     IDLIDLFED0
     I              DDCUST                      DL_DDCUST
     I              DDFAMT                      DL_FAMT

     ISDIACUDD0
     I              DDCUST                      @@CUST
     I              DDCNA1                      @@CNA1
     I              DDCNA2                      @@CNA2
     I              DDISDT                      @DISDT

     ISDICCTXD0
     I              DDCUST                      @@CUST

     ISDIJACMD0
     I              DDCUST                      @@CUST

     ISDINAHLD0
     I              DDISDT                      @AISDT
     I              DDSREF                      @@SREF
     I              DDMDNM                      @@MDNM

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C/COPY GOCPYSRC,GOUPD_PARM

     C                   IF        CAP002 = 'Y'

     C                   IF        Key_Desc = 'UnrepRPGInvalidAPI'
     C                   EXSR      SRINVAPI
     C                   ENDIF

     C                   IF        Key_Desc = 'UnrepRPGValidAPI'
     C                   EXSR      SRVALAPI
     C                   ENDIF

     C                   IF        %Open(GPDWNLL0)
     C                   CLOSE     GPDWNLL0
     C                   ENDIF

     C/COPY GOCPYSRC,GOUPD_DWNL

     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN

      /EJECT
      *****************************************************************
      *                                                               *
      * SRINVAPI - Routine to read file for Invalid API Transactions  *
      *            and updates record count accordingliy.             *
      *                                                               *
      *****************************************************************

     C     SRINVAPI      BEGSR

      ** If the Midas phase is not Input Cycle then set data to blank.

     C                   IF        MidasPhase = 'C'
     C                   EVAL      Value = *BLANKS
     C                   ELSE
     C                   EVAL      CountN = 0

     C     *LOVAL        SETLL     APITRANL0
     C                   READ      APITRANL0                              01
     C                   DOW       *IN01 = *OFF
     C                   EVAL      CountN = CountN + 1
     C                   READ      APITRANL0                              01
     C                   ENDDO

     C     *LOVAL        SETLL     APITRANL1
     C                   READ      APITRANL1                              01
     C                   DOW       *IN01 = *OFF
     C                   EVAL      CountN = CountN + 1
     C                   READ      APITRANL1                              01
     C                   ENDDO

     C                   EVAL      Value = CountA

     C                   ENDIF

     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      * SRVALAPI - Routine to read file for Valid API Transactions    *
      *            and updates record count accordingliy.             *
      *                                                               *
      *****************************************************************

     C     SRVALAPI      BEGSR

      ** If the Midas phase is not Input Cycle then set data to blank.

     C                   IF        MidasPhase = 'C'
     C                   EVAL      Value = *blanks
     C                   ELSE
     C                   EVAL      CountN = 0

     C     *LOVAL        SETLL     APVTRANL0
     C                   READ      APVTRANL0                              01
     C                   DOW       *IN01 = *OFF
     C                   EVAL      CountN = CountN + 1
     C                   READ      APVTRANL0                              01
     C                   ENDDO

     C     *LOVAL        SETLL     APVTRANL1
     C                   READ      APVTRANL1                              01
     C                   DOW       *IN01 = *OFF
     C                   EVAL      CountN = CountN + 1
     C                   READ      APVTRANL1                              01
     C                   ENDDO

     C                   EVAL      Value = CountA

     C                   ENDIF

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial processing                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

      ** Check if CAP002 is Installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD             7
     C                   PARM      '*VERIFY'     WOPTN             7
     C                   PARM      'CAP002'      WSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY

     C     WRTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CAP002
     C                   ELSE
     C                   MOVEL     'N'           CAP002
     C                   ENDIF

     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      *****************************************************************
