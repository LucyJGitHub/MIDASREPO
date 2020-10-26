     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Group A/c Shadow Posting Replication')        *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE101601 - Group A/c Shadow Posting Replication              *
      *                                                               *
      *  Function:  This module receives journal images from journal  *
      *             ICJRN representing updates to the shadow account  *
      *             movements file. If the entry is across a sub      *
      *             account in a group a/c hierarchy, then it is      *
      *             replicated up the hierarchy.                      *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR679670           Date 26Nov10               *
      *                 AR676213           Date 19Nov10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 16Mar10               *
      *                 CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  AR679670 - Apply fix 255837                                  *
      *  255837 - Fix overdraft validation.  Amend program so that    *
      *           BAIC (Balance Available ICO) of the sub/level a/c's *
      *           which are used to determine the cleared balance     *
      *           of the level & top a/c's are to be updated with     *
      *           a transaction against a sub-account.                *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  CAP204 - Teller Related APIs - Account Transfer (Recompile)  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************

     FREGARSPD  UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     FREGAHLJ0  IF   E           K DISK    INFSR(*PSSR)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AC_)
     FREGAHLL0  IF   E           K DISK    INFSR(*PSSR)                                       255837
     F                                     RENAME(REGAHLD0:REGAHLD1)                          255837
     F                                     PREFIX(AD_)                                        255837

      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************

     D I_PACD          S             10  0                                                    CGL029

      ** Chain Arrays
     D***O_GLAI*         S             18    DIM(99)                                          CGL029
     D O_GLAI          S             24    DIM(99)                                            CGL029
     D O_RAN           S             10    DIM(99)
     D O_AST           S              1    DIM(99)
     D O_PC            S              4    DIM(99)
     D O_ASC           S              2    DIM(99)
     D O_ODFT          S             15S 0 DIM(99)
     D O_BAIC          S              1    DIM(99)
     D O_ICTB          S             15S 0 DIM(99)

      ** Chain Arrays
     D***I_GLAI*         S             18    DIM(99)                                          CGL029
     D I_GLAI          S             24    DIM(99)                                            CGL029
     D I_RAN           S             10    DIM(99)
     D I_AST           S              1    DIM(99)
     D I_PC            S              4    DIM(99)
     D I_ASC           S              2    DIM(99)
     D I_ODFT          S             15S 0 DIM(99)
     D I_BAIC          S              1    DIM(99)
     D I_ICTB          S             15S 0 DIM(99)


      * Entry To Replicate
     D I_RSACMT      E DS                  EXTNAME(RSACMTPD)
     D                                     PREFIX(R_)

      * Entry To Replicate
     D I_FFACMV      E DS                  EXTNAME(FFACMVD)
     D                                     PREFIX(F_)


     D JournalEnt      DS
      * Standard fields on all journal entries
     D  Filler01                      5A
     D  JrnSeqn                      10A
     D  JrnCode                       1A
     D  JrnEntType                    2A
     D  Filler02                     12A
     D  JobName                      10A
     D  Filler03                     16A
     D  Program                      10A
     D  Object                       10A
     D  Library                      10A
     D  Member                       10A
     D  Filler04                     29A
      * The journal entry
     D  Entry                       500A

     D ControlInf      DS
     D  CTRLInfo1                     1
     D  CTRLInfo2                     1


      * If the first byte of Control Information is 0, no data has been
      *  passed so simply return

     C                   IF        CTRLInfo1 = '0'
     C                   RETURN
     C                   ENDIF

      * If 'terminate replication' requested
      *   Update the last journal sequence number processed on REGARSPD
      *   and end this program

     C     JrnEntType    IFEQ      'TR'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      UPD_REGARS
     C                   COMMIT
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF

      * Determine if replication is required

     C                   EXSR      DET_REPL

      * If Replication is required
      *    Construct a CM Hierarchy Chain
      *    Replicate the entry

     C     Repl_Reqd     IFEQ      'Y'
     C                   EXSR      CON_HCHN
     C                   EXSR      REPLICATE
     C                   ENDIF

      * Update the last journal sequence number processed on REGARSPD

     C                   EXSR      UPD_REGARS

      * Commit the updates

     C                   COMMIT

     C                   RETURN

      /SPACE 5
      *********************************************************************
      * Determine if replication is required
      *********************************************************************
     C     DET_REPL      BEGSR

      * Replication required?

     C                   MOVEL     'Y'           Repl_Reqd         1

     C     Program       IFEQ      'FF0450'
     C     JobName       OREQ      'CM_GAC_REP'

     C                   MOVEL     'N'           Repl_Reqd

     C                   ELSE

      * Entry is for file RSACMTPD or FFACMVD

     C                   MOVEL     *BLANK        AC_RECI
     C                   MOVEL     *BLANKS       WBAIC             1                          255837

     C     Object        IFEQ      'RSACMTPD'

     C                   EVAL      I_RSACMT = Entry
     C     ACCNTK_R      CHAIN     REGAHLJ0                           60        *
     C     REGAHL_K      CHAIN     REGAHLL0                           61                      255837
     C     *IN61         IFEQ      '0'                                                        255837
     C                   MOVEL     AD_GLBAIC     WBAIC                                        255837
     C                   ENDIF                                                                255837
     C  N60ACCNTK_R      CHAIN     ACCNTABF                           60

     C                   ELSE

     C                   EVAL      I_FFACMV = Entry
     C     ACCNTK_F      CHAIN     REGAHLJ0                           60        *
     C     REGAHL_K      CHAIN     REGAHLL0                           61                      255837
     C     *IN61         IFEQ      '0'                                                        255837
     C                   MOVEL     AD_GLBAIC     WBAIC                                        255837
     C                   ENDIF                                                                255837
     C  N60ACCNTK_F      CHAIN     ACCNTABF                           60

     C                   ENDIF

      * If the entry account is not a sub a/c in a group a/c hierarchy
      * or if the acount is not found or is closed
      *   Don't replicate this entry

     C     *in60         IFEQ      '1'
     C     AC_RECI       ORNE      'D'
     C                   MOVEL     'N'           Repl_Reqd
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Construct a CM Hierarchy Chain
      ********************************************************************
     C     CON_HCHN      BEGSR

     C                   CALLB     'RE100604'

      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS

      * INPUTS
      * Hierarchy ID
     C                   PARM      CLHIER        I_HIER            9 0
      * Hierarchy Type
     C                   PARM      'GA'          I_HTYP            2
      * Parent branch
      * Parent customer
      * Parent currency
      * Parent a/c code
      * Parent a/c seq.
     C                   PARM      CLPBRC        I_PBRC            3
     C**********         PARM      CLPCUS        I_PCUS            6 0                        CSD027
     C                   PARM      CLPCUS        I_PCUS            6                          CSD027
     C                   PARM      CLPCCY        I_PCCY            3
     C**********         PARM      CLPACD        I_PACD            4 0                        CGL029
     C                   PARM      CLPACD        I_PACD                                       CGL029
     C                   PARM      CLPASN        I_PASN            2 0

      * OUTPUTS
      * CHAINS FOR:
      * GL Account ID
      * Retail A/c No.
      * A/c Status
      * Profit Centre
      * A/c Section
      * Overdraft
      * Balance Available for I/C Overdraft
      * I/C Threshold Balance
     C                   PARM                    O_GLAI
     C                   PARM                    O_RAN
     C                   PARM                    O_AST
     C                   PARM                    O_PC
     C                   PARM                    O_ASC
     C                   PARM                    O_ODFT
     C                   PARM                    O_BAIC
     C                   PARM                    O_ICTB
      * Count in chain
     C                   PARM                    O_CNTCH           2 0

      * End if error occurred in module

     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EVAL      X_ERMS = 'HIERARCHY CHAIN ' +
     C                                      'CONTRUCTION FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF

                                                                                              255837
      ** Move BAIC field of sub/level into that of the next account in the hierarchy          255837
      ** so that RE100720 will know whether or not to update the cleared balance of           255837
      ** the level/top accounts.                                                              255837
                                                                                              255837
     C                   Z-ADD     99            WC                2 0                        255837
     C                   Z-ADD     0             WP                2 0                        255837
     C     WC            DOWGT     1                                                          255837
     C     WC            SUB       1             WP                                           255837
     C                   MOVEL     O_BAIC(WP)    O_BAIC(WC)                                   255837
     C                   SUB       1             WC                                           255837
     C                   ENDDO                                                                255837
     C                   MOVEL     WBAIC         O_BAIC(1)                                    255837
                                                                                              255837
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      *********************************************************************
      * Replicate the entry
      *********************************************************************
     C     REPLICATE     BEGSR

     C                   CALLB     'RE100607'

      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS

      * INPUTS
      * RSAMCTPD Entry To Replicate
      * FFACMVD Entry To Replicate
     C                   PARM                    I_RSACMT
     C                   PARM                    I_FFACMV
      * File Name
      * Member Name
     C                   PARM      Object        I_FILE           10
     C                   PARM      Member        I_MEMBER         10
      * Hierarchy ID
     C                   PARM      CLHIER        I_HIER            9 0
      * Retail a/c number
      * Level
     C                   PARM      AC_ACNO       I_ACNO           10 0
     C                   PARM      CLLEVL        I_LEVL            2 0
      * CHAINS FOR:
      * GL Account ID
      * Retail A/c No.
      * A/c Status
      * Profit Centre
      * A/c Section
      * Overdraft
      * Balance Available for I/C Overdraft
      * I/C Threshold Balance
     C                   PARM      O_GLAI        I_GLAI
     C                   PARM      O_RAN         I_RAN
     C                   PARM      O_AST         I_AST
     C                   PARM      O_PC          I_PC
     C                   PARM      O_ASC         I_ASC
     C                   PARM      O_ODFT        I_ODFT
     C                   PARM      O_BAIC        I_BAIC
     C                   PARM      O_ICTB        I_ICTB
      * Count in chain
     C                   PARM      O_CNTCH       I_CNTCH           2 0

     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EVAL      X_ERMS = 'REPLICATION FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Update the last journal sequence number processed on REGARSPD
      *********************************************************************
     C     UPD_REGARS    BEGSR

     C     1             CHAIN     REGARSD0                           60
     C     *in60         IFEQ      '0'
     C                   EVAL      GSLJES = JrnSeqn
     C                   UPDATE    REGARSD0
     C                   ELSE
     C                   EVAL      CTRLInfo1 = '9'
     C                   EVAL      X_ERMS = 'MISSING REGARSPD RECORD'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    JournalEnt
     C                   PARM                    ControlInf

      * Key lists

     C     ACCNTK_F      KLIST
     C                   KFLD                    F_CUSN
     C                   KFLD                    F_CCYD
     C                   KFLD                    F_ACDE
     C                   KFLD                    F_ASNC
     C                   KFLD                    F_BRCA

     C     ACCNTK_R      KLIST
     C                   KFLD                    R_CUSN
     C                   KFLD                    R_CCYD
     C                   KFLD                    R_ACDE
     C                   KFLD                    R_ASNC
     C                   KFLD                    R_BRCA

     C     REGAHL_K      KLIST                                                                255837
     C                   KFLD                    CLHIER                                       255837
     C                   KFLD                    CLLINK                                       255837
                                                                                              255837
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
