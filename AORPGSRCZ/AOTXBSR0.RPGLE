     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Tax Basket Maintenance Access Object')
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOTXBSR0 - Tax Basket Maintenance Access Object              *
      *                                                               *
      *  Function:  This program access details from SDTXBSPD         *
      *             with parameters of Country of Treaty, Tax Basket, *
      *             and Input Date and return a Narrative and Tax Rate*
      *             which has an effective date less than or equal to *
      *             the Input Date                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 233593             Date 19May05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  233593 - Mismatch between *NRF and *ERROR on AOTXBSR0        *
      *  CSE023 - Treaty Withholding Tax                              *
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
     FSDTXBSL1  IF   E           K DISK    USROPN
     F                                     RENAME(SDTXBSD0:@TXBSL1)
      ** Tax Basket Details - Retrieve
      *
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
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
      *
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
     C                   IF        *IN01 = '0'
     C                   EVAL      *IN91 = '1'
     C                   ELSE
     C                   EVAL      *IN91 = '0'
     C                   ENDIF
     C                   EXSR      SRReturn
     C                   ENDIF
      *
      ** Initialise Error Indicators
      *
     C                   MOVEA     '0000000'     *IN(90)
      *
      ** First call - open file
      *
     C                   IF        *IN01 = '0'
     C                   EVAL      *IN01 = '1'
     C                   OPEN      SDTXBSL1                             91
     C                   IF        *IN91
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
      *
      ** Last Call - Close File and terminate program
      *
     C                   IF        P@OPTN = '*FREE  '
     C                   CLOSE     SDTXBSL1                             92
     C                   IF        *IN92
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      *INLR = '1'
     C                   ENDIF
      *
      ** Caller requests first record
      *
     C                   IF        P@OPTN = '*FIRST '
     C     *LOVAL        SETLL     @TXBSL1                            9390
     C                   IF        *IN93 or *IN90
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      P@OPTN = '*NEXT  '
     C                   ENDIF
      *
      ** Caller requests next record
      *
     C                   IF        P@OPTN = '*NEXT  '
     C                   READ      @TXBSL1                              9094
     C                   IF        *IN94 or *IN90
     C                   EXSR      SRReturn
     C                   ELSE
     C                   EVAL      P@NARR = TBNARR
     C                   EVAL      P@RATE = TBTRAB
     C                   ENDIF
     C                   ENDIF
      *
      ** Caller requests last record
      *
     C                   IF        P@OPTN = '*LAST  '
     C     *HIVAL        SETGT     @TXBSL1                              90
     C                   IF        *IN90
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      P@OPTN = '*PREV  '
     C                   ENDIF
      *
      ** Caller requests previous record
      *
     C                   IF        P@OPTN = '*PREV  '
     C                   READP     @TXBSL1                              9094
     C                   IF        *IN94 or *IN90
     C                   EXSR      SRReturn
     C                   ELSE
     C                   EVAL      P@NARR = TBNARR
     C                   EVAL      P@RATE = TBTRAB
     C                   ENDIF
     C                   ENDIF
      *
      ** Caller requests record indicated by key
      *
     C                   IF        P@OPTN = '*KEY   ' or P@OPTN = '*VERIFY'
      *
     C     KEY1          SETGT     @TXBSL1
     C**********         READP     @TXBSL1                                90                  233593
     C                   READP     @TXBSL1                              9095                  233593
      *
     C                   IF        *IN90 = '0' and P@CRTT = TBCRTT
     C                             and P@TXBS = TBTXBS
     C                             and *IN95 = *OFF                                           233593
     C                   EVAL      P@NARR = TBNARR
     C                   EVAL      P@RATE = TBTRAB
     C                   ELSE
     C                   EVAL      *IN95 = '1'
     C                   ENDIF
      *
     C                   IF        *IN95 or *IN90
     C                   EXSR      SRReturn
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        P@OPTN <> '*KEY   '
     C                             and P@OPTN <> '*NEXT  '
     C                             and P@OPTN <> '*PREV  '
     C                             and P@OPTN <> '*VERIFY'
     C                             and P@OPTN <> '*FREE  '
     C                   EVAL      *IN96 = '1'
     C                   ENDIF
      *
     C                   EXSR      SRReturn
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
     C     *IN90         WHENEQ    '1'
     C                   EVAL      P@RTCD = '*ERROR '
     C                   EVAL      *INLR = '1'
     C     *IN91         WHENEQ    '1'
     C                   EVAL      P@RTCD = '*OPEN  '
     C                   EVAL      *INLR = '1'
     C     *IN92         WHENEQ    '1'
     C                   EVAL      P@RTCD = '*CLOSE '
     C                   EVAL      *INLR = '1'
     C     *IN93         WHENEQ    '1'
     C                   EVAL      P@RTCD = '*EMPTY '
     C     *IN94         WHENEQ    '1'
     C                   EVAL      P@RTCD = '*EOF   '
     C     *IN95         WHENEQ    '1'
     C                   EVAL      P@RTCD = '*NRF   '
     C     *IN96         WHENEQ    '1'
     C                   EVAL      P@RTCD = '*OPTION'
     C                   ENDSL
      *
      ** Caller requests message sent to program queue
      *
     C                   IF        W@RTCD = '*MSG   ' and P@RTCD <> *BLANKS
      *
     C                   SELECT
     C     *IN90         WHENEQ    '1'
     C                   EVAL      P@MGID = 'ACO1001'
     C     *IN91         WHENEQ    '1'
     C                   EVAL      P@MGID = 'ACO1002'
     C     *IN92         WHENEQ    '1'
     C                   EVAL      P@MGID = 'ACO1003'
     C     *IN93         WHENEQ    '1'
     C                   EVAL      P@MGID = 'ACO1004'
     C     *IN94         WHENEQ    '1'
     C                   EVAL      P@MGID = 'ACO1005'
     C     *IN95         WHENEQ    '1'
     C                   EVAL      P@MGID = 'ACO1006'
     C     *IN96         WHENEQ    '1'
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
     C     W@RTCD        PARM                    P@RTCD            7
     C                   PARM                    P@OPTN            7
     C                   PARM                    P@CRTT            2
     C                   PARM                    P@TXBS            2
     C                   PARM                    P@DATE            5 0
     C                   PARM                    P@NARR           15
     C                   PARM                    P@RATE            6 4
      *
      ** Initialise Key Lists
      *
     C     KEY1          KLIST
     C                   KFLD                    P@CRTT
     C                   KFLD                    P@TXBS
     C                   KFLD                    P@DATE
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2001
** @MG
SDTXBSPD  AOTXBSR0  Tax Basket Details
