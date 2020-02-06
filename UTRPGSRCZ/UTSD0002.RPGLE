     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Utility to update invalid data')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  UTSD0002 - Utility to update invalid data in Customer and    *
      *             Branch file                                       *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BG12468 *CREATE    Date 07Nov06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG12468 - Update invalid data in Customer and Branch file    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCUSTL0  UF   E           K DISK
     FSDCUSTL1  IF   E           K DISK
     FSDACSTL0  UF   E           K DISK    RENAME(SDCUSTD0:SDACSTD0)
     FSDACSTL1  IF   E           K DISK    RENAME(SDCUSTD0:SDACSTD1)
     FSDBRCHL0  UF   E           K DISK    PREFIX(A_)
     FSDBRCHL1  IF   E           K DISK    PREFIX(B_)
     FSDABRCL0  UF   E           K DISK    RENAME(SDBRCHD0:SDABRCD0)
     F                                     PREFIX(C_)
     FSDABRCL1  IF   E           K DISK    RENAME(SDBRCHD0:SDABRCD1)
     F                                     PREFIX(D_)
 
     FSDFCTLL0  UF   E           K DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D SMCASE          S              1    DIM(26) CTDATA PERRCD(26)
     D UPCASE          S              1    DIM(26) CTDATA PERRCD(26)
     D BRCA            S              1    DIM(3)
     D WKCNUM          S              1    DIM(6)
     D WKCSSN          S              1    DIM(10)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D WFnd            S              1
     D KFile           S             10
     D KBRCA           S              3
     D KCNUM           S              6
     D WDEL            S              3  0
     D X               S              2  0 INZ(1)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EXSR      SRAcpBrch
     C                   EXSR      SRBranch
 
     C                   IF        WDel > *ZERO
     C                   EVAL      KFile = 'SDBRCHPD'
     C     KFile         CHAIN     SDFCTLL0
     C                   IF        %FOUND(SDFCTLL0)
     C                   EVAL      AHNORC = AHNORC - WDEL
     C                   EVAL      AHNODL = AHNODL + WDEL
     C                   UPDATE    @AHREAU
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRAcpCust
     C                   EXSR      SRCust
 
     C                   IF        WDel > *ZERO
     C                   EVAL      KFile = 'SDCUSTPD'
     C     KFile         CHAIN     SDFCTLL0
     C                   IF        %FOUND(SDFCTLL0)
     C                   EVAL      AHNORC = AHNORC - WDEL
     C                   EVAL      AHNODL = AHNODL + WDEL
     C                   UPDATE    @AHREAU
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcpBrch                                                    *
      *                                                               *
      *****************************************************************
     C     SRAcpBrch     BEGSR
 
     C     *LOVAL        SETLL     SDABRCL0
     C                   READ      SDABRCL0
 
     C                   EVAL      WDEL = 0
 
     C                   DOW       NOT %EOF(SDABRCL0)
 
     C                   MOVEA     C_A8BRCD      BRCA
     C                   MOVE      'N'           WFnd
 
     C     BRCA(1)       LOOKUP    SMCASE(X)                              70
     C                   IF        *IN70 = *ON
     C                   MOVE      UPCASE(X)     BRCA(1)
     C                   ENDIF
     C                   EVAL      X = 1
     C     BRCA(2)       LOOKUP    SMCASE(X)                              71
     C                   IF        *IN71 = *ON
     C                   MOVE      UPCASE(X)     BRCA(2)
     C                   ENDIF
     C                   EVAL      X = 1
     C     BRCA(3)       LOOKUP    SMCASE(X)                              72
     C                   IF        *IN72 = *ON
     C                   MOVE      UPCASE(X)     BRCA(3)
     C                   ENDIF
 
     C                   IF        *IN70 = *ON
     C                             OR *IN71 = *ON
     C                             OR *IN72 = *ON
     C                   MOVEA     BRCA          KBRCA
     C                   EXSR      SRChkABrch
     C                   ENDIF
 
     C                   READ      SDABRCL0
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     SrChkABrch    BEGSR
 
     C     KBRCA         CHAIN     SDABRCL1
     C                   IF        %FOUND(SDABRCL1)
     C                   EVAL      WFnd = 'Y'
     C                   ENDIF
 
     C                   IF        WFnd = 'N'
     C                   MOVEA     BRCA          C_A8BRCD
     C                   UPDATE    SDABRCD0
     C                   ENDIF
 
     C                   IF        WFnd = 'Y'
     C                   DELETE    SDABRCD0
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBranch                                                     *
      *                                                               *
      *****************************************************************
     C     SRBranch      BEGSR
 
     C     *LOVAL        SETLL     SDBRCHL0
     C                   READ      SDBRCHL0
 
     C                   EVAL      WDEL = 0
 
     C                   DOW       NOT %EOF(SDBRCHL0)
 
     C                   MOVEA     A_A8BRCD      BRCA
     C                   MOVE      'N'           WFnd              1
 
     C     BRCA(1)       LOOKUP    SMCASE(X)                              70
     C                   IF        *IN70 = *ON
     C                   MOVE      UPCASE(X)     BRCA(1)
     C                   ENDIF
     C                   EVAL      X = 1
     C     BRCA(2)       LOOKUP    SMCASE(X)                              71
     C                   IF        *IN71 = *ON
     C                   MOVE      UPCASE(X)     BRCA(2)
     C                   ENDIF
     C                   EVAL      X = 1
     C     BRCA(3)       LOOKUP    SMCASE(X)                              72
     C                   IF        *IN72 = *ON
     C                   MOVE      UPCASE(X)     BRCA(3)
     C                   ENDIF
 
     C                   IF        *IN70 = *ON
     C                             OR *IN71 = *ON
     C                             OR *IN72 = *ON
     C                   MOVEA     BRCA          KBRCA
     C                   EXSR      SRChkBrch
     C                   ENDIF
 
     C                   READ      SDBRCHL0
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     SrChkBrch     BEGSR
 
     C     KBRCA         CHAIN     SDBRCHL1
     C                   IF        %FOUND(SDBRCHL1)
     C                   EVAL      WFnd = 'Y'
     C                   ENDIF
 
     C                   IF        WFnd = 'N'
     C                   MOVEA     BRCA          A_A8BRCD
     C                   UPDATE    @A8REB1
     C                   ENDIF
 
     C                   IF        WFnd = 'Y'
     C                   DELETE    @A8REB1
     C                   EVAL      WDel = WDEL + 1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcpCust                                                    *
      *                                                               *
      *****************************************************************
     C     SRAcpCust     BEGSR
 
     C     *LOVAL        SETLL     SDACSTL0
     C                   READ      SDACSTL0
 
     C                   EVAL      WDEL = 0
 
     C                   DOW       NOT %EOF(SDACSTL0)
 
     C                   MOVEA     BBCUST        WkCNUM
     C                   MOVEA     BBCSSN        WkCSSN
     C                   MOVE      'N'           WFnd
 
     C     WKCNUM(1)     LOOKUP    SMCASE(X)                              60
     C                   IF        *IN60 = *ON
     C                   MOVE      UPCASE(X)     WKCNUM(1)
     C                   ENDIF
     C                   EVAL      X = 1
     C     WKCNUM(2)     LOOKUP    SMCASE(X)                              61
     C                   IF        *IN61 = *ON
     C                   MOVE      UPCASE(X)     WKCNUM(2)
     C                   ENDIF
     C                   EVAL      X = 1
     C     WKCNUM(3)     LOOKUP    SMCASE(X)                              62
     C                   IF        *IN62 = *ON
     C                   MOVE      UPCASE(X)     WKCNUM(3)
     C                   ENDIF
     C     WKCNUM(4)     LOOKUP    SMCASE(X)                              63
     C                   IF        *IN63 = *ON
     C                   MOVE      UPCASE(X)     WKCNUM(4)
     C                   ENDIF
     C                   EVAL      X = 1
     C     WKCNUM(5)     LOOKUP    SMCASE(X)                              64
     C                   IF        *IN64 = *ON
     C                   MOVE      UPCASE(X)     WKCNUM(5)
     C                   ENDIF
     C                   EVAL      X = 1
     C     WKCNUM(6)     LOOKUP    SMCASE(X)                              65
     C                   IF        *IN65 = *ON
     C                   MOVE      UPCASE(X)     WKCNUM(6)
     C                   ENDIF
 
     C     WKCSSN(1)     LOOKUP    SMCASE(X)                              70
     C                   IF        *IN70 = *ON
     C                   MOVE      UPCASE(X)     WKCSSN(1)
     C                   ENDIF
     C                   EVAL      X = 1
     C     WKCSSN(2)     LOOKUP    SMCASE(X)                              71
     C                   IF        *IN71 = *ON
     C                   MOVE      UPCASE(X)     WKCSSN(2)
     C                   ENDIF
     C                   EVAL      X = 1
     C     WKCSSN(3)     LOOKUP    SMCASE(X)                              72
     C                   IF        *IN72 = *ON
     C                   MOVE      UPCASE(X)     WKCSSN(3)
     C                   ENDIF
     C     WKCSSN(4)     LOOKUP    SMCASE(X)                              73
     C                   IF        *IN73 = *ON
     C                   MOVE      UPCASE(X)     WKCSSN(4)
     C                   ENDIF
     C                   EVAL      X = 1
     C     WKCSSN(5)     LOOKUP    SMCASE(X)                              74
     C                   IF        *IN74 = *ON
     C                   MOVE      UPCASE(X)     WKCSSN(5)
     C                   ENDIF
     C                   EVAL      X = 1
     C     WKCSSN(6)     LOOKUP    SMCASE(X)                              75
     C                   IF        *IN75 = *ON
     C                   MOVE      UPCASE(X)     WKCSSN(6)
     C                   ENDIF
     C     WKCSSN(7)     LOOKUP    SMCASE(X)                              76
     C                   IF        *IN76 = *ON
     C                   MOVE      UPCASE(X)     WKCSSN(7)
     C                   ENDIF
     C                   EVAL      X = 1
     C     WKCSSN(8)     LOOKUP    SMCASE(X)                              77
     C                   IF        *IN77 = *ON
     C                   MOVE      UPCASE(X)     WKCSSN(8)
     C                   ENDIF
     C                   EVAL      X = 1
     C     WKCSSN(9)     LOOKUP    SMCASE(X)                              78
     C                   IF        *IN78 = *ON
     C                   MOVE      UPCASE(X)     WKCSSN(9)
     C                   ENDIF
     C     WKCSSN(10)    LOOKUP    SMCASE(X)                              79
     C                   IF        *IN79 = *ON
     C                   MOVE      UPCASE(X)     WKCSSN(10)
     C                   ENDIF
 
     C                   IF        *IN60 = *ON
     C                             OR *IN61 = *ON
     C                             OR *IN62 = *ON
     C                             OR *IN63 = *ON
     C                             OR *IN64 = *ON
     C                             OR *IN65 = *ON
     C                             OR *IN70 = *ON
     C                             OR *IN71 = *ON
     C                             OR *IN72 = *ON
     C                             OR *IN73 = *ON
     C                             OR *IN74 = *ON
     C                             OR *IN75 = *ON
     C                             OR *IN76 = *ON
     C                             OR *IN77 = *ON
     C                             OR *IN78 = *ON
     C                             OR *IN79 = *ON
     C                   MOVEA     WkCNUM        KCNUM
     C                   EXSR      SRChkACust
     C                   ENDIF
 
     C                   READ      SDACSTL0
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     SrChkACust    BEGSR
 
     C     KCNUM         CHAIN     SDACSTL1
     C                   IF        %FOUND(SDACSTL1)
     C                   IF        *IN60 = *ON OR *IN61 = *ON OR
     C                             *IN62 = *ON OR *IN63 = *ON OR
     C                             *IN64 = *ON OR *IN65 = *ON
     C                   EVAL      WFnd = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WFnd = 'N'
     C                   MOVEA     WKCNUM        BBCUST
     C                   MOVEA     WKCSSN        BBCSSN
     C                   UPDATE    SDACSTD0
     C                   ENDIF
 
     C                   IF        WFnd = 'Y'
     C                   DELETE    SDACSTD0
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCust                                                       *
      *                                                               *
      *****************************************************************
     C     SRCust        BEGSR
 
     C     *LOVAL        SETLL     SDCUSTL0
     C                   READ      SDCUSTL0
 
     C                   EVAL      WDEL = 0
 
     C                   DOW       NOT %EOF(SDCUSTL0)
 
     C                   MOVEA     BBCUST        WKCNUM
     C                   MOVEA     BBCSSN        WkCSSN
     C                   MOVE      'N'           WFnd
 
     C     WKCNUM(1)     LOOKUP    SMCASE(X)                              60
     C                   IF        *IN60 = *ON
     C                   MOVE      UPCASE(X)     WKCNUM(1)
     C                   ENDIF
     C                   EVAL      X = 1
     C     WKCNUM(2)     LOOKUP    SMCASE(X)                              61
     C                   IF        *IN61 = *ON
     C                   MOVE      UPCASE(X)     WKCNUM(2)
     C                   ENDIF
     C                   EVAL      X = 1
     C     WKCNUM(3)     LOOKUP    SMCASE(X)                              62
     C                   IF        *IN62 = *ON
     C                   MOVE      UPCASE(X)     WKCNUM(3)
     C                   ENDIF
     C     WKCNUM(4)     LOOKUP    SMCASE(X)                              63
     C                   IF        *IN63 = *ON
     C                   MOVE      UPCASE(X)     WKCNUM(4)
     C                   ENDIF
     C                   EVAL      X = 1
     C     WKCNUM(5)     LOOKUP    SMCASE(X)                              64
     C                   IF        *IN64 = *ON
     C                   MOVE      UPCASE(X)     WKCNUM(5)
     C                   ENDIF
     C                   EVAL      X = 1
     C     WKCNUM(6)     LOOKUP    SMCASE(X)                              65
     C                   IF        *IN65 = *ON
     C                   MOVE      UPCASE(X)     WKCNUM(6)
     C                   ENDIF
 
     C     WKCSSN(1)     LOOKUP    SMCASE(X)                              70
     C                   IF        *IN70 = *ON
     C                   MOVE      UPCASE(X)     WKCSSN(1)
     C                   ENDIF
     C                   EVAL      X = 1
     C     WKCSSN(2)     LOOKUP    SMCASE(X)                              71
     C                   IF        *IN71 = *ON
     C                   MOVE      UPCASE(X)     WKCSSN(2)
     C                   ENDIF
     C                   EVAL      X = 1
     C     WKCSSN(3)     LOOKUP    SMCASE(X)                              72
     C                   IF        *IN72 = *ON
     C                   MOVE      UPCASE(X)     WKCSSN(3)
     C                   ENDIF
     C     WKCSSN(4)     LOOKUP    SMCASE(X)                              73
     C                   IF        *IN73 = *ON
     C                   MOVE      UPCASE(X)     WKCSSN(4)
     C                   ENDIF
     C                   EVAL      X = 1
     C     WKCSSN(5)     LOOKUP    SMCASE(X)                              74
     C                   IF        *IN74 = *ON
     C                   MOVE      UPCASE(X)     WKCSSN(5)
     C                   ENDIF
     C                   EVAL      X = 1
     C     WKCSSN(6)     LOOKUP    SMCASE(X)                              75
     C                   IF        *IN75 = *ON
     C                   MOVE      UPCASE(X)     WKCSSN(6)
     C                   ENDIF
     C     WKCSSN(7)     LOOKUP    SMCASE(X)                              76
     C                   IF        *IN76 = *ON
     C                   MOVE      UPCASE(X)     WKCSSN(7)
     C                   ENDIF
     C                   EVAL      X = 1
     C     WKCSSN(8)     LOOKUP    SMCASE(X)                              77
     C                   IF        *IN77 = *ON
     C                   MOVE      UPCASE(X)     WKCSSN(8)
     C                   ENDIF
     C                   EVAL      X = 1
     C     WKCSSN(9)     LOOKUP    SMCASE(X)                              78
     C                   IF        *IN78 = *ON
     C                   MOVE      UPCASE(X)     WKCSSN(9)
     C                   ENDIF
     C     WKCSSN(10)    LOOKUP    SMCASE(X)                              79
     C                   IF        *IN79 = *ON
     C                   MOVE      UPCASE(X)     WKCSSN(10)
     C                   ENDIF
 
     C                   IF        *IN60 = *ON
     C                             OR *IN61 = *ON
     C                             OR *IN62 = *ON
     C                             OR *IN63 = *ON
     C                             OR *IN64 = *ON
     C                             OR *IN65 = *ON
     C                             OR *IN70 = *ON
     C                             OR *IN71 = *ON
     C                             OR *IN72 = *ON
     C                             OR *IN73 = *ON
     C                             OR *IN74 = *ON
     C                             OR *IN75 = *ON
     C                             OR *IN76 = *ON
     C                             OR *IN77 = *ON
     C                             OR *IN78 = *ON
     C                             OR *IN79 = *ON
     C                   MOVEA     WkCNUM        KCNUM
     C                   EXSR      SRChkCust
     C                   ENDIF
 
     C                   READ      SDCUSTL0
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     SrChkCust     BEGSR
 
     C     KCNUM         CHAIN     SDCUSTL1
     C                   IF        %FOUND(SDCUSTL1)
     C                   IF        *IN60 = *ON OR *IN61 = *ON OR
     C                             *IN62 = *ON OR *IN63 = *ON OR
     C                             *IN64 = *ON OR *IN65 = *ON
     C                   EVAL      WFnd = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WFnd = 'N'
     C                   MOVEA     WKCNUM        BBCUST
     C                   MOVEA     WKCSSN        BBCSSN
     C                   UPDATE    @BBREBG
     C                   ENDIF
 
     C                   IF        WFnd = 'Y'
     C                   DELETE    @BBREBG
     C                   EVAL      WDEL = WDEL + 1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
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
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**CTDATA SMCASE
abcdefghijklmnopqrstuvwxyz
**CTDATA UPCASE
ABCDEFGHIJKLMNOPQRSTUVWXYZ
