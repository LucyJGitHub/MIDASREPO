     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Print Unauthorised Correspondence')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG0085 - Print Unauthorised Correspondence                   *
      *                                                               *
      *  Function:  This program displays a list of unauthorised      *
      *             Correpondence for printing.                       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD012             Date 15Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD012 - Standing Data Authorisation                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FCG0085DF  CF   E             WORKSTN
     F                                     SFILE(CG0085S0:@@RRN)
      ** Midas CG Print Unauthorised Correspondence
 
     FSDAULGL4  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Authorisation Log - by Correspondence
 
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
 
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      ** Get Rundate - Rundate
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D W0RSF           S              1
     D WQA3N           S              3  0
     D WQB3N           S              3  0
     D WQC3N           S              3  0
     D WQD1            S              1
     D WQE1            S              1
     D WQF1            S              1
     D WQB10X          S             10
     D WQG3N           S              3  0
     D WSkipRec        S              1
     D @RUN            S              1
     D CPY2@           S             80
 
     D I#DTA           DS           256
      *
      ** Input parameters data structure
      *
      **          Spool file name (if blank, name unchanged).
      **                N.B. To change name I#SPLR must be Y
      **                Unless first call of program
      *
     D  I#SPLN                 1     10
      *
      **          Repeat open and close of spool file
      **                If Y create new spool file
      *
     D  I#SPLR                11     11
      *
      **          Report Reference if Access checking is off
      *
     D  I#REFN                12     21
      *
      **          Report Override Flag / Page No.
      *
     D  I#ROVR                22     22
     D  I#PAGE                23     25  0
      *
      **          Report Title/Underline (uses msg ID on CGUSRMSG)
      *
     D  I#TITL                26     32
     D  I#TUL                 33     39
      *
      ** Define fields for group set printing
      *
     D  I#CORR                40     49
 
     D/COPY CGCPYSRC,SRERRDLE
      ** Fields, data structures, arrays definition for CG error processing
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Main Program
 
     C                   DO        *HIVAL
 
      ** If no records found, display error message and exit
 
     C     *LOVAL        SETLL     SDAULGL4
     C                   READ      SDAULGL4                               82
      *
     C                   IF        *IN82 = '1'
     C                   EVAL      PZMsgID = 'USR7590'
     C                   EXSR      SRZasnms
     C                   EXFMT     CG0085NR
     C                   EXSR      SREnd
     C                   ENDIF
 
      ** Initialise and load subfile page
 
     C                   EXSR      SRBuild
 
     C                   EVAL      W0RSF = 'N'
 
      ** Display screen until reload requested
 
     C     W0RSF         DOWEQ     'N'
 
      ** Display screen
     C                   EXSR      SRDisplay
 
      ** Process response
 
     C     *IN03         CASEQ     '1'           SREnd
 
     C     *IN05         CASEQ     '1'           SRReload
 
     C     *IN27         CASEQ     '1'           SRLoad
 
     C                   CAS                     SRProcess
     C                   ENDCS
 
     C                   ENDDO
 
     C                   ENDDO
 
      /EJECT
      *****************************************************************
      * SRBuild - Initialise and Load Subfile Page                    *
      *                                                               *
      * Called by: Main routine                                       *
      * Calls    : QDCXLATE, SRLoad                                   *
      *****************************************************************
     C     SRBuild       BEGSR
 
      ** Initialise & load subfile page
 
     C                   EVAL      *IN80 = *ON
     C                   WRITE     CG0085C0
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN81 = *OFF
 
      ** Reset Number of Records in Subfile
 
     C                   Z-ADD     0             WLRCD             4 0
 
      ** Position file
     C     KAUTH1        KLIST
     C                   KFLD                    DDFNSL
     C                   KFLD                    DDKYSL
 
     C     KAUTH1        SETLL     SDAULGL4
     C                   READ      SDAULGL4
 
      ** Save previous selector values
 
     C     *LIKE         DEFINE    DDKYSL        WZKYSL
     C                   EVAL      WZKYSL = DDKYSL
     C     *LIKE         DEFINE    DDFNSL        WZFNSL
     C                   EVAL      WZFNSL = DDFNSL
 
      ** Translate search mask for text field
 
     C     *LIKE         DEFINE    DDKYSL        WQKYSL
 
     C                   CALL      'QDCXLATE'
     C                   PARM      20            WQA5N             5 0
     C                   PARM      DDKYSL        WQKYSL
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X           10
 
     C     *LIKE         DEFINE    DDFNSL        WQFNSL
 
     C                   CALL      'QDCXLATE'
     C                   PARM      21            WQA5N
     C                   PARM      DDFNSL        WQFNSL
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X
 
      ** Load subfile page
 
     C                   EXSR      SRLoad
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRLoad - Load Subfile Page                                    *
      *                                                               *
      * Called by: Main routine, SRBuild                              *
      * Calls    : QCLSCAN                                            *
      *****************************************************************
     C     SRLoad        BEGSR
 
      ** Re-establish fields in read-ahead record
 
     C                   IF        *IN27 and *IN82 = '0'
     C                   READP     SDAULGL4                               60
     C                   READ      SDAULGL4                               60
     C                   ENDIF
 
      ** Start at previous highest record in SFL
 
     C                   Z-ADD     WLRCD         @@RRN
     C                   Z-ADD     1             WRCTR             5 0
 
      ** Load next subfile page
 
     C     *IN82         DOWEQ     '0'
     C     WRCTR         ANDLE     WSFPG
 
     C                   EVAL      WSkipRec = 'N'
     C                   ADD       1             @@RRN
     C                   EVAL      *IN32 = '0'
 
      ** Protect fields during Enquiry Mode
 
     C                   IF        DDKYSL <> *BLANKS
 
     C                   CALL      'QCLSCAN'
     C                   PARM                    ALKEY
     C                   PARM      20            WQA3N
     C                   PARM      1             WQB3N
     C                   PARM                    WQKYSL
     C                   PARM      20            WQC3N
     C                   PARM      '1'           WQD1
     C                   PARM      '1'           WQE1
     C                   PARM      '?'           WQF1
     C                   PARM                    WQG3N
 
     C                   IF        WQG3N < 1
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDFNSL <> *BLANKS
 
     C                   CALL      'QCLSCAN'
     C                   PARM                    ALFUNC
     C                   PARM      21            WQA3N
     C                   PARM      1             WQB3N
     C                   PARM                    WQFNSL
     C                   PARM      21            WQC3N
     C                   PARM      '1'           WQD1
     C                   PARM      '1'           WQE1
     C                   PARM      '?'           WQF1
     C                   PARM                    WQG3N
 
     C                   IF        WQG3N < 1
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WSkipRec = 'N'
 
      ** Load subfile fields
 
     C                   MOVE      *BLANK        DDOPTN
     C                   MOVEL     ALKEY         DDKEY
     C                   MOVEL     ALFUNC        DDFUNC
     C                   MOVE      ALACTN        DDACTN
     C                   MOVE      ALUSER        DDUSER
 
      ** Output to subfile
 
     C                   ADD       1             WRCTR                81
     C                   EVAL      *IN81 = *ON
     C                   WRITE     CG0085S0
 
     C                   ELSE
     C                   SUB       1             @@RRN
     C                   ENDIF
 
      ** End of File
 
     C                   READ      SDAULGL4                               82
     C                   ENDDO
 
     C                   Z-ADD     @@RRN         WLRCD
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRReload - Request Subfile Reload                             *
      *                                                               *
      * Called by: Main routine, SRProcess                            *
      * Calls    :                                                    *
      *****************************************************************
     C     SRReload      BEGSR
 
      ** Request subfile reload
 
     C                   EVAL      W0RSF = 'Y'
 
     C                   IF        *IN05
     C                   MOVE      '0'           *IN32
     C                   MOVE      '0'           *IN94
      *
     C                   EVAL      DDOPTN = *Blanks
     C                   EVAL      DDKEY = *Blanks
     C                   EVAL      DDFUNC = *Blanks
     C                   EVAL      DDACTN = *Blanks
     C                   EVAL      DDUSER = *Blanks
      *
      ** Clear messages from program message queue
     C                   CALL      'ZA0250'
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRDisplay - Display Subfile                                  *
      *                                                               *
      *  Called by: Main routine                                      *
      *  Calls    :                                                   *
      *****************************************************************
     C     SRDisplay     BEGSR
 
      ** PUTOVR unless conditioned fields change
 
     C                   EVAL      *IN86 = *ON
 
     C                   TIME                    DDTIME
     C                   WRITE     CG0085C1
     C                   WRITE     CG0085F0
     C                   EXFMT     CG0085C0
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRProcess - Process Screen Input                              *
      *                                                               *
      * Called by: Main routine                                       *
      * Calls    : SRReload, SRValid, SRPrint                         *
      *****************************************************************
     C     SRProcess     BEGSR
 
      ** Change of position specified
 
     C                   IF        WZKYSL <> DDKYSL OR WZFNSL <> DDFNSL
     C                   EXSR      SRReload
     C                   ENDIF
 
      ** Quit if reload requested
 
     C     W0RSF         IFNE      'Y'
 
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
 
     C                   MOVE      '0'           *IN94
 
     C                   READC     CG0085S0                               99
     C     *IN99         DOWEQ     '0'
      *
      * Validate option code
     C                   EXSR      SRValid
      *
      ** If action code is valid process selection
      *
     C     *IN32         IFEQ      '0'
     C     DDOPTN        ANDNE     *BLANK
     C                   EXSR      SRPrint
     C                   ENDIF
      *
     C     *IN32         IFEQ      '0'
     C                   EVAL      DDOPTN = *Blanks
     C                   EVAL      W0RSF = 'Y'
     C                   ENDIF
      *
     C                   UPDATE    CG0085S0
     C                   READC     CG0085S0                               99
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRValid - Validate Option code                                *
      *                                                               *
      * Called by: SRProcess                                          *
      * Calls    : SRZasnms                                           *
      *****************************************************************
     C     SRValid       BEGSR
 
     C                   MOVE      '0'           *IN32
      *
      ** Validate Action Code
     C                   If        DDOPTN <> 'P' AND DDOPTN <> ' '
     C                   MOVE      '1'           *IN32
     C                   MOVE      '1'           *IN94
     C                   EVAL      PZMsgID = 'USR9269'
     C                   EXSR      SRZasnms
     C                   Endif
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRPrint - Print Selected transaction                          *
      *                                                               *
      * Called by: SRProcess                                          *
      * Calls    : Authorisation Programs, SREnd, SRZasnms            *
      *****************************************************************
     C     SRPrint       BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRPRNT'      @STK(Q)
      *
      ** Print selected call FC0040X to submit job CGC1150
      *
      ** Clear data structure and set report printed
      *
     C                   CLEAR                   I#DTA
      *
      ** Set up data to pass
      *
     C                   MOVEL     'CG0090P1'    I#SPLN
     C                   MOVEL     'Y'           I#SPLR
     C                   MOVEL     *BLANKS       I#REFN
     C                   MOVEL     'CG0090P1'    I#REFN
      *
     C                   MOVEL     'CGD1172'     I#TITL
     C                   MOVEL     'CGD1173'     I#TUL
     C                   MOVEL     DDKEY         I#CORR
      *
      ** Set to system report
      *
     C                   MOVEL     'S'           O#LVL                          Level
     C                   MOVEL     *BLANKS       O#ENTY                         Entity
      *
     C                   MOVEL     *BLANKS       O#PARM
     C                   MOVEL     I#DTA         O#PARM
      *
      ** Call FC0040X to report movements
      *
     C                   CALL      'FC0040X'                            90      Call FC0040X RC
     C                   PARM      *BLANKS       O#RTN             7
     C                   PARM      'CG0090'      O#PRG            10            Calling Program
     C                   PARM      'CGC0091'     O#CPRG           10            CL Controlling
     C                   PARM      '10001'       O#CSEQ            5            CL Sequence Num
     C                   PARM                    O#PARM          100            Calling Paramet
     C                   PARM      AGMBIN        O#MBIN            1            Multi-Branching
     C                   PARM                    O#LVL             1            Level
     C                   PARM                    O#ENTY            3            Entity
      *
      ** Unwind subroutine stack name
      *
     C     EXPRNT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SREnd - End Program                                           *
      *                                                               *
      * Called by: Main routine, SRPrint                              *
      * Calls    :                                                    *
      *****************************************************************
     C     SREnd         BEGSR
 
      ** Terminate program
 
     C                   EVAL      *INLR = *ON
 
      ** Exit program
 
     C                   RETURN
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRZasnms - Message Handling Subroutine                        *
      *                                                               *
      * Called by: Various                                            *
      * Calls    : ZA0340                                             *
      *****************************************************************
     C     SRZasnms      BEGSR
 
     C                   IF        PZMsgFile = *BLANKS
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   ENDIF
 
     C                   CALL      'ZA0340'
     C                   PARM                    PZMsgFile        10
     C                   PARM                    PZMsgID          10
 
     C                   EVAL      PZMsgFile = *BLANKS
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *  Calls    : *PSSR                                             *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Initialize program name
 
     C                   MOVEL     'CG0085'      DBPGM
 
      ** Get Rundate - Rundate
 
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
 
      ** Move workstation ID to screen field
 
     C                   EVAL      ##PGMQ = ##PGM
     C                   EVAL      DDUSR  = ##USR
     C                   EVAL      DDWID  = ##JOB
 
      ** Initialise Subfile Control
 
     C                   MOVE      *BLANKS       DDFNSL
     C                   Z-ADD     13            WSFPG             3 0
 
     C                   ENDSR
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY CGCPYSRC,SRERRCLE
      /EJECT
     C/COPY CGCPYSRC,SRERRPSSRL
      /EJECT
