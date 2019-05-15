     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SC Open Month End SQL Statements')
/*XBI *****************************************************************
/*XBI *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000106 - Open Month End SQL Statements                     *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSC024  *CREATE    Date 07Feb05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC024 - Open Month End                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR - Initialisation                                      *
      *  *PSSR  - Program exception error routine                     *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** SQL scripts
     FSCOMETXT  UF A E           K DISK    USROPN
     F                                     RENAME(SCOMETXT:SCOMTXD0)
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Work Array
     D WrkArray        S             70    DIM(4) CTDATA PERRCD(1)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PZone           S             10
     D PCoBInd         S              1
     D PRetCode        S             10
 
     D PCommandLine    S             80
     D PCommandLen     S             15  5
 
     D WRun            S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Override file
 
     C                   EVAL      PCommandLine = WrkArray(1)
     C                   CALL(E)   'QCMDEXC'
     C                   PARM                    PCommandLine
     C                   PARM      80            PCommandLen
     C                   IF        NOT %ERROR
 
     C                   OPEN(E)   SCOMETXT
     C                   IF        %ERROR
     C                   EVAL      PRetCode = '*ERROR'
     C                   ELSE
 
      ** SQL statements are compressed when they are put into the file
      ** During CoB, update T_LGSUBS and T_LGSTAT
 
     C                   IF        PCoBInd = 'Y'
     C                   EVAL      SRCSEQ = 1
     C                   EVAL      SRCDTA = WrkArray(2)
     C                   WRITE(E)  SCOMTXD0
     C
     C                   EVAL      SRCSEQ = 2
     C                   EVAL      SRCDTA = '''' + PZone + ''';'
     C                   WRITE(E)  SCOMTXD0
 
     C                   EVAL      SRCSEQ = 3
     C                   EVAL      SRCDTA = WrkArray(3)
     C                   WRITE(E)  SCOMTXD0
 
     C                   ELSE
 
      ** During System set-up, update T_TRPLYST
 
     C                   EVAL      SRCSEQ = 1
     C                   EVAL      SRCDTA = WrkArray(4)
     C                   WRITE(E)  SCOMTXD0
     C
     C                   EVAL      SRCSEQ = 2
     C                   EVAL      SRCDTA = '''' + PZone + ''';'
     C                   WRITE(E)  SCOMTXD0
     C                   ENDIF
 
     C                   IF        %ERROR
     C                   EVAL      PRetCode = '*ERROR'
     C                   ENDIF
 
     C                   CLOSE     SCOMETXT
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      PRetCode = '*ERROR'
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initialisation                                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PZone
     C                   PARM                    PCoBInd
     C                   PARM                    PRetCode
 
      ** Set up Local Data Area
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = *BLANKS
     C                   EVAL      DBKey = *BLANKS
     C                   EVAL      DBPgm = *BLANKS
     C                   EVAL      DBPgm = 'SC000106'
     C                   EVAL      DBase = *ZERO
     C                   OUT       LDA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2005
**  WrkArray
OVRDBF FILE(SCOMETXT) MBR(OME) SHARE(*NO) SECURE(*YES)
UPDATE T_LGSUBS SET STATUS = 'Active' WHERE CODE = 'OME' AND ZONE =
UPDATE T_LGSTAT SET STATUS = 'ACTIVE';
UPDATE T_TRPLYST SET STATUS='ACTIVE' WHERE TYPE='BACKVALUE' AND ZONE=
