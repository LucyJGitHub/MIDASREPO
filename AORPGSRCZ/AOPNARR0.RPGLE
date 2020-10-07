     H DEBUG
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
      *****************************************************************
/*S*DF***RPGBASE*******************************************************              CSD053 MD056543
/*S*D ***RPGBNOCVT*****************************************************                     MD056543
/*STD *  RPGBASEMOD                                                   *                     MD056543
/*E*S ***RPGCVTOPT1****************************************************              CSD053 MD056543
/*EXI *  TEXT('Midas AO Obtain Posting Narrative')
/*OVRF*: OVRDBF (CGSTMTLU) (CGSTMTL1)                               : *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  AOPNARR0 - Obtain Posting Narrative                          *
      *                                                               *
      *  Function:  This program obtains a User Defined Posting       *
      *             Narrative and returns it, with substituted data   *
      *             if required.                                      *
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056543           Date 15Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSC042             Date 16Jan09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD053             Date 01Jun06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 160168             DATE 25MAY95               *
      *                 089151             DATE 24MAR95               *
      *                 086125             DATE 16MAR95               *
      *                 S01522             DATE 15MAR95               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD to readable  *
      *             unicode equivalent.                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC042 - COB Performance fix. Turn off LOGCLPGM during       *
      *           execution of CGC0100                                *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *         - (Recompile)                                         *
      *  160168 - Client stmts show posting narratives in wrong Lang. *
      *  089151 - If not found pass back narrative                    *
      *  086125 - Add new parameter and change DB errs                *
      *  S01522 - User Defined Correspondence                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ~~~~~~~~~~~~~~~                                              *
      *                                                               *
      *  50   -    No Record/End of File on LF/CGCORRL3               *
      *  51   -    No Record/End of File on LF/CGCORRL4               *
      *  60   -    Look-Up Indicator                                  *
      *  90   -    General Purpose Error Indicator                    *
      *                                                               *
      *                                                               *
      *****************************************************************
      *................................................................
      *
     FCGCORRL3  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FCGCORRL4  IF   E           K DISK
     F                                     INFSR(SRFILE)
      /EJECT
      *
      **  Customer/Language Table
     D #CUS            S              6    DIM(10)
     D #LNG            S              2    DIM(10)
      *
      **  Branch/Language Table
     D #BRC            S              3    DIM(100)
     D #LGB            S              2    DIM(100)
      *
      **  Copyright array.
      * Commands                                                                              CSC042
     D #CMD            S             40    DIM(2) CTDATA PERRCD(1)                            CSC042
      /COPY CGCPYSRC,SRERRDLE
      /EJECT
      *
     D ##PRM1          DS                                                                     086125
      **  Data Structure for Customer and Branch                                              086125
      *                                                                                       086125
     D  ##CUST                 1      6                                                       086125
     D  ##BRCA                 7      9                                                       086125
      *                                                                                       086125
     D ##PARM        E DS                  EXTNAME(CGPNARPD)
      **  External DS for parameters based on PF/CGPNARPD
      *
     D ##TXT2          DS           512
      **  Define ##TXT2 field
      *
     D CPYR            DS
      **  Data Structure for Compilation - Copyright Insertion
     D  ##CPY                  1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
      **  Set up Constants
     D C#MSGF          C                   CONST('CGPNARMSG ')
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *   Index to subroutines                                        *
      *   --------------------                                        *
      *                                                               *
      *   SRMAIN - Main processing                                    *
      *   SRINZ  - Initialise Fields on Each Invocation               *
      *   SRINIT - Initial processing - On First Call                 *
      *   *PSSR  - Exception/Error Handling                           *
      *   SRFILE - File Exception/Error Handling                      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * Process     :  MAINLINE                                       *
      * Function    :  Mainline processing                            *
      *                                                               *
      * Called by   :  None                                           *
      * Calls       :  SRINIT - Initial Processing - On First Call    *
      *                SRINZ  - Initialise Fields on Each Invocation  *
      *                SRMAIN - Main Processing                       *
      *****************************************************************
      *
      **  Parameter list for current program invocation.
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN             7
     C                   PARM                    ##MGID            7
     C     ##PRM1        PARM                    I#PRM1            9                          086125
     C                   PARM                    ##PARM
     C                   PARM                    ##PNAR           50
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      *................................................................
      *
      **  Initial processing - Once Only
     C     ##INIT        IFEQ      *BLANK
     C                   EXSR      SRINIT
     C                   MOVE      'Y'           ##INIT            1
     C                   ENDIF
      *
      **  Initialisation processing
     C                   EXSR      SRINZ
      *
      **  Detail process
     C                   EXSR      SRMAIN
      *
      *................................................................
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      **  Terminate program
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * Subroutine  :  SRMAIN                                         *
      * Function    :  Main processing                                *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  CGC0100 - Extract Message Information          *
      *                SRERR   - Error Handling                       *
      *****************************************************************
     C     SRMAIN        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRMAIN'      @STK(Q)
      *
      *................................................................
      *
      **  Retrieve the Customer Language ID from the stored array
     C                   Z-ADD     1             I                 3 0
     C***********MNCUST    LOKUP#CUS,I                   60                                   086125
     C     ##CUST        LOOKUP    #CUS(I)                                60                  086125
      *
      **  If a match is found, set up the Language ID.
     C     *IN60         IFEQ      *ON
     C                   MOVE      #LNG(I)       ##LGID
      *
      **  If no match is found, access the Correspondent file for the
      **  Customer.
     C                   ELSE
     C***********MNCUST    CHAINCGCORRL4             51                                       086125
     C     ##CUST        CHAIN     CGCORRL4                           51                      086125
      *
      **  If no record found, Database Error
     C     *IN51         IFEQ      *ON
     C*                                                                                       086125
     C* Set Language to blanks                                                                086125
     C*                                                                                       086125
     C                   MOVEL     *BLANKS       CDLGID                                       086125
     C***********                                                                             086125
     C***********          MOVEL'CGCORRL4'W0FILE                                              086125
     C***********          MOVELMNCUST    W0KEY            ***************                    086125
     C***********          Z-ADD01        W0ERNB           * DB ERROR 01 *                    086125
     C***********          MOVEL'MEM5004' W0MSGD           ***************                    086125
     C***********          MOVEL'MIDAS  ' W0MSGF                                              086125
     C***********          EXSR SRERR                                                         086125
     C                   ENDIF
      *
      **  Set up the Language ID.
     C                   MOVE      CDLGID        ##LGID
      *
      **  Increment the 'Last Customer Array Element Used' index
     C                   ADD       1             ##LCEU            3 0
     C     ##LCEU        IFEQ      11
     C                   Z-ADD     1             ##LCEU
     C                   ENDIF
      *
      **  Set up/replace the Customer ID for this element
     C                   Z-ADD     ##LCEU        I
     C***********        MOVE CDCUST    #CUS,I                                                160168
     C                   MOVE      ##CUST        #CUS(I)                                      160168
     C                   ENDIF
      *
      **  If the Language Id retrieved is blank, obtain the Branch
      **  default.
     C     ##LGID        IFEQ      *BLANKS
     C                   Z-ADD     2             J
     C***********MNBRCA    LOKUP#BRC,J                   60                                   086125
     C     ##BRCA        LOOKUP    #BRC(J)                                60                  086125
      *
      **  If a match is found, set up the Language ID.
     C     *IN60         IFEQ      *ON
     C                   MOVE      #LGB(J)       ##LGID
      *
      **  If no match is found, access the Correspondent file for the
      **  Branch.
     C                   ELSE
     C***********MNBRCA    CHAINCGCORRL3             50                                       086125
     C     ##BRCA        CHAIN     CGCORRL3                           50                      086125
      *
      **  If no record found, Database Error
     C     *IN50         IFEQ      *ON
     C*                                                                                       086125
     C* Set Language to blanks                                                                086125
     C*                                                                                       086125
     C                   MOVEL     *BLANKS       CDLGID                                       086125
     C***********                                                                             086125
     C***********          MOVEL'CGCORRL3'W0FILE                                              086125
     C***********          MOVELMNBRCA    W0KEY            ***************                    086125
     C***********          Z-ADD02        W0ERNB           * DB ERROR 02 *                    086125
     C***********          MOVEL'MEM5004' W0MSGD           ***************                    086125
     C***********          MOVEL'MIDAS  ' W0MSGF                                              086125
     C***********          EXSR SRERR                                                         086125
     C                   ENDIF
      *
      **  Set up the Language ID.
     C                   MOVE      CDLGID        ##LGID
     C                   ENDIF
     C                   ENDIF
      *
      **  If the Language Id retrieved is still blank, obtain the
      **  SYSTEM default.
     C     ##LGID        IFEQ      *BLANKS
     C                   Z-ADD     1             J
     C                   MOVE      #LGB(J)       ##LGID
     C                   ENDIF
      *
      **  If the Language Id retrieved is still blank, process a
      **  database error.
     C     ##LGID        IFEQ      *BLANKS
     C                   MOVEL     'CGCORRL3'    W0FILE
     C                   MOVEL     'SYSTEM  '    W0KEY                          ***************
     C                   Z-ADD     03            W0ERNB                         * DB ERROR 03 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      **  Set up/replace the Language ID for this element
     C                   MOVE      ##LGID        #LNG(I)
      *
      **  Set up the Posting Narrative Message ID.
     C                   MOVEL     ##LGID        ##MGID
     C                   MOVEL     C#MSGF        ##MSGF
      *                                                                                       089151
      * Check position of 4 of message id to make sure it is                                  089151
      * from 0 to 9 and A to F                                                                089151
      *                                                                                       089151
     C                   MOVEL     *BLANKS       ##P4              1                          089151
     C     1             SUBST     ##MGID:4      ##P4                                         089151
     C                   SELECT                                                               089151
     C     ##P4          WHENGE    '0'                                                        089151
     C     ##P4          ANDLE     '9'                                                        089151
     C     ##P4          ORGE      'A'                                                        089151
     C     ##P4          ANDLE     'F'                                                        089151
     C                   OTHER                                                                089151
     C                   MOVEL(P)  MNNARR        ##PNAR                                       089151
     C                   GOTO      EXMAIN                                                     089151
     C                   ENDSL                                                                089151
      *
      * Retrieve the JOBA for LOGCLPGM if not done already                                    CSC042
     C     #LOGCL        IFNE      'Y'                                                        CSC042
     C                   MOVEL     'Y'           #LOGCL            1                          CSC042
     C                   CALL      'CGC0100I'                                                 CSC042
     C                   PARM                    #LOGG            10                          CSC042
     C                   MOVEL     #LOGG         #LOG4             4                          CSC042
     C                   END                                                                  CSC042
      *                                                                                       CSC042
      * If LOGCLPGM is *YES then set it to *NO for the duration of CGC0100                    CSC042
      * and then set it back to *YES afterwards                                               CSC042
     C     #LOG4         IFNE      '*NO '                                                     CSC042
     C                   MOVEL     #CMD(2)       ##CMD            40                          CSC042
     C                   CALL      'QCMDEXC'                                                  CSC042
     C                   PARM                    ##CMD                                        CSC042
     C                   PARM      40            #CLEN            15 5                        CSC042
     C                   END                                                                  CSC042
      *                                                                                       CSC042
      **  Format the Posting Narrative
     C                   CALL      'CGC0100'
     C                   PARM                    ##MGID
     C                   PARM                    ##MSGF           10
     C                   PARM                    ##PARM
     C                   PARM                    ##TXT1          132
     C                   PARM                    ##TXT2
     C                   PARM      *BLANK        ##RTCD            7
      *                                                                                       CSC042
      *  Set the LOGCLPGM back to what it was before doing anything else                      CSC042
     C     #LOG4         IFNE      '*NO '                                                     CSC042
     C                   MOVEL     #CMD(1)       ##CMD                                        CSC042
     C                   CALL      'QCMDEXC'                                                  CSC042
     C                   PARM                    ##CMD                                        CSC042
     C                   PARM      40            #CLEN                                        CSC042
     C                   END                                                                  CSC042
      *
      **  If the Return Code is not blank and not '*NRF' (No Record
      **  Found), process a Database Error.
     C     ##RTCD        IFNE      *BLANK
     C     ##RTCD        ANDNE     '*NRF   '
      *
     C                   MOVEL     'CGC0100 '    W0FILE                         ***************
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 04 *
     C                   Z-ADD     04            W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      **  Finally extract the Posting Narrative.
     C     ##RTCD        IFNE      '*NRF   '
     C                   MOVEL     ##TXT1        ##PNAR
     C                   ELSE                                                                 089151
     C                   MOVEL(P)  MNNARR        ##PNAR                                       089151
     C                   ENDIF
      *
      *................................................................
      *
     C     EXMAIN        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Subroutine  :  SRINZ                                          *
      * Function    :  Initialise Fields on Program Invocation        *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRINZ         BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRINZ '      @STK(Q)
      *
      *................................................................
      *
      **  Initialise fields ........
     C                   MOVE      *BLANKS       ##PNAR
      *
      *  If ##CUST is blank then use MNCUST                                                   086125
      *                                                                                       086125
     C     ##CUST        IFEQ      *BLANKS                                                    086125
     C                   MOVEL     MNCUST        ##CUST                                       086125
     C                   ENDIF                                                                086125
      *                                                                                       086125
      *  If ##BRCA is blank then use MNBRCA                                                   086125
      *                                                                                       086125
     C     ##BRCA        IFEQ      *BLANKS                                                    086125
     C                   MOVEL     MNBRCA        ##BRCA                                       086125
     C                   ENDIF                                                                086125
      *................................................................
      *
     C     EXINZ         TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Subroutine  :  SRINIT                                         *
      * Function    :  Initial processing - First Call Only           *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      *................................................................
      *
      **  Initialise Branch/Language Code table.
     C                   Z-ADD     1             J                 3 0
     C                   MOVEA     *HIVAL        #BRC
     C                   MOVEA     *HIVAL        #LGB
      *
      **  Access the Customer Correspondent file by Branch
     C     *LOVAL        SETLL     CGCORRL3
     C                   READ      CGCORRL3                               50
      *
      **  Load an array of Language Code by Branch (up to 100 elements)
      **  (Note that SYSTEM value will always be in 1st element,
      **   Branch Code blank)
     C     J             DOWLT     101
     C     *IN50         ANDEQ     *OFF
      *
     C                   MOVE      CDBRCA        #BRC(J)
     C                   MOVE      CDLGID        #LGB(J)
     C                   ADD       1             J
      *
      **  Access the Customer Correspondent file by Branch
     C                   READ      CGCORRL3                               50
      *
     C                   ENDDO
      *
      **  Key lists ..........
      *
      **  Define work fields .............
     C     *LIKE         DEFINE    CDLGID        ##LGID
      *
      **  Copyright
     C                   MOVEA     ##CPY         ##BIS            80
      *
      *................................................................
      *
     C     EXINIT        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      /COPY CGCPYSRC,SRERRPSSRL
      /EJECT
      /COPY CGCPYSRC,SRERRCLE
**CTDATA ##CPY OBJECT COPYRIGHT
(c) Finastra International Limited 2001
**CTDATA #CMD - CSC042
CHGJOB JOB(*) LOGCLPGM(*YES)
CHGJOB JOB(*) LOGCLPGM(*NO)
