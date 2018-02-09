     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Data Replication Configurator Update')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCRPCNUPD - Data Replication Configurator Database Update    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
 
      ** Data Replication File Definition Detail File
     FSCFDTLL0  UF A E           K DISK    USROPN
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
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
 
      ** Replication Details File before update to file
     D DtaRepFilfmt  E DS                  EXTNAME(SCFDTLPD)
     D                                     PREFIX(VL:2)
 
      ** Replication Details File
     D NwRepFilFmt   E DS                  EXTNAME(SCFDTLPD)
 
      ** Current Data Replication Record (for Amend)
     D CrRepFilFmt   E DS                  EXTNAME(SCFDTLPD)
     D                                     PREFIX(Cr)
 
      ** SC24x7 Data Area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
     D Command         DS           250
     D  Action                38     38
     D  PhyFile               42     51
     D  LogFile               55     64
     D  RPGName               94    103
     D  PrevRPGName          107    116
     D  JobDSys              141    142
     D  JobQSys              161    162
     D  WCommand               1    250
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Replication Record Format Name
     D RepRecFmt       S             10
 
     D PActCde         S              1
 
      ** Parameters for QCMDEXC
     D CommandLen      S             15  5
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - MAIN BODY                                              *
      *                                                               *
      *****************************************************************
 
     C                   OPEN      SCFDTLL0
 
      ** Initialise Previous Flds
 
     C                   CLEAR                   CrRepFilFmt
 
      ** Insert, Amend or Delete
 
     C     PActCde       CASEQ     'I'           SRInsert
     C     PActCde       CASEQ     'A'           SRAmend
     C     PActCde       CASEQ     'D'           SRDelete
     C                   ENDCS
 
     C                   CLOSE     SCFDTLL0
 
     C                   RETURN
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRInsert - Insert Data Replication Details                   *
      *                                                              *
      * Called by: Main Processing                                   *
      *                                                              *
      * Calls:     SRSetFlds                                         *
      *                                                              *
      ****************************************************************
     C     SRInsert      BEGSR
 
      ** Access File
 
     C     VLPHYF        CHAIN     SCFDTLL0                           89
 
      ** Database error
 
     C                   IF        *IN89 = *OFF
     C                   EVAL      DBKEY  = VlPHYF
     C                   EVAL      DBFILE = 'SCFDTLL0'
     C                   EVAL      DBASE  = 1
     C                   EXSR      SRERR
     C                   ENDIF
 
      ** Initialize Transaction Detail
 
     C                   CLEAR                   NwRepFilFmt
 
     C                   EXSR      SRSetFlds
     C                   WRITE     SCFDTLD0
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRSetFld - Set up fields for File Update                     *
      *                                                              *
      * Called by: SRInsert, SRAmend                                 *
      *                                                              *
      * Calls:     None                                              *
      *                                                              *
      ****************************************************************
     C     SRSetFlds     BEGSR
 
     C                   EVAL      NwRepFilFmt  = DtaRepFilFmt
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRAmend - Amend Data Replication Detials                     *
      *                                                              *
      * Called by: Main Processing                                   *
      *                                                              *
      * Calls:     SRSetFlds                                         *
      *                                                              *
      ****************************************************************
     C     SRAmend       BEGSR
 
      ** Access Data Replication Detail Record
 
     C     VLPHYF        CHAIN     SCFDTLL0                           89
 
      ** Database error
 
     C                   IF        *IN89 = *ON
     C                   EVAL      DBKEY  = VLPHYF
     C                   EVAL      DBFILE = 'SCFDTLL0'
     C                   EVAL      DBASE  = 2
     C                   EXSR      SRERR
     C                   ENDIF
 
      ** Update 'BEFORE' status
 
     C                   EVAL      CrRepFilFmt = NwRepFilFmt
 
     C                   EXSR      SRSetFlds
 
      ** Update Record
 
     C                   UPDATE    SCFDTLD0
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRDelete - Delete the record                                 *
      *                                                              *
      * Called by: Main Processing                                   *
      *                                                              *
      * Calls:     None                                              *
      *                                                              *
      ****************************************************************
     C     SRDelete      BEGSR
 
      ** Access Replication Details
 
     C     VLPHYF        CHAIN     SCFDTLL0                           89
 
      ** Database error
 
     C                   IF        *IN89 = *ON
     C                   EVAL      DBKEY  = VLPHYF
     C                   EVAL      DBFILE = 'SCFDTLL0'
     C                   EVAL      DBASE  = 3
     C                   EXSR      SRERR
     C                   ENDIF
 
      ** Update 'BEFORE' status
 
     C                   EVAL      CrRepFilFmt = NwRepFilFmt
 
      ** Delete record
 
     C                   DELETE    SCFDTLD0
 
     C                   ENDSR
      ****************************************************************
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
 
      **  Program Parameters
 
     C     *ENTRY        PLIST
 
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Action Code
     C                   PARM                    PActCde
 
      ** Replication details Screen fields
     C                   PARM                    DtaRepFilFmt
 
     C                   IN        SC24X7
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                              *
      * SRERR - EXCEPTION ERRORS                                     *
      *                                                              *
      ****************************************************************
     C     SRERR         BEGSR
 
     C                   EVAL      RetCodeIn = '*ERROR '
     C                   EVAL      DBPGM = 'SCRPCNUPD'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
 
      **  Terminate the Program
 
     C                   RETURN
 
     C                   ENDSR
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2001
