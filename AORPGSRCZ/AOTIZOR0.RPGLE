     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Time Zone Access Object')
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOTIZOR0 - Midas AO Time Zone Access Object                  *
      *                                                               *
      *  Function:  This program access details from SDTIZOPD         *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         OFF on the first run                            *
      *    90         File Error                                      *
      *    91         OPEN Error                                      *
      *    92         CLOSE Error                                     *
      *    93         Empty File                                      *
      *    94         End of File                                     *
      *    95         No Record found                                 *
      *    96         OPTION Error                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRReturn      -  Return Error Code and Set Parameters        *
      *  SRINIT        -  Program Initialisation Routine              *
      *                                                               *
      *****************************************************************
      /EJECT
      ** Midas SD Time Zone - Retrieve (Time Zone Level + Year)
      *
     FSDTIZOL1  IF   E           K DISK    USROPN
     F                                     RENAME(SDTIZOD0:@TIZOL1)
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
      /EJECT
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
     D D@FMT         E DS                  EXTNAME(SDTIZOPD)
     D P@FMT         E DS                  EXTNAME(DSFDY)
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
      *
      ** Variable to determine the potision of "?"
     D WPos            S              2S 0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Main Program
      *
      ** Execute initialisation
      *
     C                   EXSR      SRINIT
      *
      ** Initialise Return Parameter
      *
     C                   IF        P@OPTN = '*SAME  '
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN91 = *ON
     C                   ELSE
     C                   EVAL      *IN91 = *OFF
     C                   ENDIF
     C                   EXSR      SRReturn
     C                   ENDIF
      *
      ** Initialise Error Indicators
      *
     C                   MOVEA     '0000000000'  *IN(90)
      *
      ** First call - open file
      *
     C                   IF        *IN01 = *Off
     C                   EVAL      *IN01 = *On
     C                   OPEN      SDTIZOL1                             91
     C                   IF        *IN91
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
      *
      ** Last Call - Close File and terminate program
      *
     C                   IF        P@OPTN = '*FREE  '
     C                   CLOSE     SDTIZOL1                             92
     C                   IF        *IN92
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
      ** Caller requests first record
      *
     C                   IF        P@OPTN = '*FIRST '
     C     *LOVAL        SETLL     SDTIZOL1                           9390
     C                   IF        *IN93 or *IN90
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      P@OPTN = '*NEXT  '
     C                   ENDIF
      *
      ** Caller requests next record
      *
     C                   IF        P@OPTN = '*NEXT  '
     C                   READ      SDTIZOL1                             9094
     C                   IF        *IN94 or *IN90
     C                   EXSR      SRReturn
     C                   ELSE
     C                   EVAL      P@FMT  = D@FMT
     C                   ENDIF
     C                   ENDIF
      *
      ** Caller requests last record
      *
     C                   IF        P@OPTN = '*LAST  '
     C     *HIVAL        SETGT     SDTIZOL1                             90
     C                   IF        *IN90
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      P@OPTN = '*PREV  '
     C                   ENDIF
      *
      ** Caller requests previous record
      *
     C                   IF        P@OPTN = '*PREV  '
     C                   READP     SDTIZOL1                             9094
     C                   IF        *IN94 or *IN90
     C                   EXSR      SRReturn
     C                   ELSE
     C                   EVAL      P@FMT  = D@FMT
     C                   ENDIF
     C                   ENDIF
      *
      ** Caller requests record indicated by key
      *
     C                   IF        P@OPTN = '*KEY   ' or P@OPTN = '*VERIFY'
      *
      ** Call for "?" on main screen
      *
     C                   EVAL      WPos = %SCAN('?':P@TZCD)
      *
     C                   IF        WPos <> *ZEROS
     C                   CALL      'SD001005S'                          98
     C                   PARM                    P@RTC2            7
     C                   PARM      P@TZCD        P@TZCD
     C                   PARM      P@YEAR        P@YEAR
     C     P@RTC2        COMP      *BLANK                             97
     C                   IF        *IN97 or *IN98
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
 
     C     KTIZO         CHAIN     SDTIZOL1                           9594
     C                   IF        NOT %FOUND(SDTIZOL1)
     C                   EVAL      P@YEAR = *Blanks
     C     KTIZO         CHAIN     SDTIZOL1                           9594
     C                   IF        NOT %FOUND(SDTIZOL1) OR *IN94
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   IF        P@OPTN <> '*KEY   '
     C                             AND P@OPTN <> '*NEXT  '
     C                             AND P@OPTN <> '*PREV  '
     C                             AND P@OPTN <> '*VERIFY'
     C                             AND P@OPTN <> '*FREE  '
     C                   EVAL      *IN96 = '1'
     C                   ENDIF
      *
     C                   EXSR      SRReturn
 
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReturn - Return Error Code and Set Parameters               *
      *                                                               *
      *  Called by: Main Program                                      *
      *                                                               *
      *  Calls    : ZASNMG, DBERRCTL                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRReturn      BEGSR
      *
      ** Return Error Code
      *
     C                   EVAL      P@RTCD = *BLANKS
      *
     C                   SELECT
 
     C                   WHEN      *IN90
     C                   EVAL      P@RTCD = '*ERROR '
     C                   EVAL      *INLR = '1'
 
     C                   WHEN      *IN91
     C                   EVAL      P@RTCD = '*OPEN  '
     C                   EVAL      *INLR = '1'
 
     C                   WHEN      *IN92
     C                   EVAL      P@RTCD = '*CLOSE '
     C                   EVAL      *INLR = '1'
 
     C                   WHEN      *IN93
     C                   EVAL      P@RTCD = '*EMPTY '
 
     C                   WHEN      *IN94
     C                   EVAL      P@RTCD = '*EOF   '
 
     C                   WHEN      *IN95
     C                   EVAL      P@RTCD = '*NRF   '
 
     C                   WHEN      *IN96
     C                   EVAL      P@RTCD = '*OPTION'
 
     C                   ENDSL
      *
      ** Caller requests message sent to program queue
      *
     C                   IF        P@RTCD = '*MSG   ' AND P@RTCD <> *BLANKS
 
     C                   SELECT
 
     C                   WHEN      *IN90
     C                   EVAL      P@MGID = 'ACO1001'
     C                   WHEN      *IN91
     C                   EVAL      P@MGID = 'ACO1002'
     C                   WHEN      *IN92
     C                   EVAL      P@MGID = 'ACO1003'
     C                   WHEN      *IN93
     C                   EVAL      P@MGID = 'ACO1004'
     C                   WHEN      *IN94
     C                   EVAL      P@MGID = 'ACO1005'
     C                   WHEN      *IN95
     C                   EVAL      P@MGID = 'ACO1006'
     C                   WHEN      *IN96
     C                   EVAL      P@MGID = 'ACO1007'
 
     C                   ENDSL
      *
     C                   CALLB     'ZASNMG'
     C                   PARM      *BLANKS       W@RTCD            7
     C                   PARM      PSProcName    P@PGNM           10
     C                   PARM      '*PRV'        P@DEST            5
     C                   PARM                    P@MGID            7
     C                   PARM      *BLANKS       P@MSGF           10
     C                   PARM      *BLANKS       P@MGKY            4
     C                   PARM                    P@MGDA           50
     C                   PARM      '*DIAG'       P@MGTP            7
      *
     C                   ENDIF
      *
      ** Caller requests DB Handling
      *
     C                   IF        W@RTCD = '*DBERR ' and P@RTCD <> *BLANKS
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
      *
      ** Return to caller
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Program Initialisation Routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Receive entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    P@RTCD            7
     C                   PARM                    P@OPTN            7
     C                   PARM                    P@TZCD           10
     C                   PARM                    P@YEAR            4
     C                   PARM      D@FMT         P@FMT
      *
      ** Define Key Lists
      *
     C     KTIZO         KLIST
     C                   KFLD                    P@TZCD
     C                   KFLD                    P@YEAR
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2008
** @MG
SDTXBSPD  AOTIZOR0  Time Zone
