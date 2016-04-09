     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO DST Access Object')
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AODSTCR0 - Daylight Saving Time Access Object                *
      *                                                               *
      *  Function:  This program access details from SDDSTCPD         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG21289           Date 13Oct08               *
      *  Prev Amend No. CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG21289 - Various Timezone and DST errors. Applied fix 21068*
      *  BUG21068 - Time zone error message wrong - it should say     *
      *             that DST code not exist for current year          *
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
     FSDDSTCL1  IF   E           K DISK    USROPN
      ** Daylight Saving Time File - Retrieve
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
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** File information data structure for external file DSFDY
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** File information data structure for external file SDDSTCPD
     D SDDSTC        E DS                  EXTNAME(SDDSTCPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D P@RtCd          S              7A
     D P@Optn          S              7A
     D P@DSTC          S             10A
     D P@DSTY          S              4A
     D P@DSTP          S            117A
      *
     D W@RtCd          S              7A
     D P@PgNm          S             10A
     D P@Dest          S              5A
     D P@MgId          S              7A
     D P@MsgF          S             10A
     D P@MgKy          S              4A
     D P@MgDt          S             50A
     D P@MgTp          S              7A
 
      ** Variable to determine the position of "?"
     D WPos            S              2S 0
      *
      ** Parameter for 'SD001006S'
     D P@RtCd2         S              7
     D P@DSTC2         S             10
     D P@DSTY2         S              4
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Execute initialisation
      *
     C                   EXSR      SrInit
      *
      ** Initialise Return Parameter
      *
     C                   IF        P@Optn = '*SAME  '
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
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN01 = *ON
     C                   OPEN      SDDSTCL1                             91
     C                   IF        *IN91
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
      *
      ** Last Call - Close File and terminate program
      *
     C                   IF        P@Optn = '*FREE  '
     C                   CLOSE     SDDSTCL1                             92
     C                   IF        *IN92
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
      ** Caller requests first record
      *
     C                   IF        P@Optn = '*FIRST '
     C     *LOVAL        SETLL     SDDSTCL1                           9390
     C                   IF        *IN93 or *IN90
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      P@Optn = '*NEXT  '
     C                   ENDIF
      *
      ** Caller requests next record
      *
     C                   IF        P@Optn = '*NEXT  '
     C                   READ      SDDSTCL1                             9094
     C                   IF        *IN90 or *IN94
     C                   EXSR      SRReturn
     C                   ELSE
     C                   EVAL      DSFDY = SDDSTC
     C                   ENDIF
     C                   ENDIF
      *
      ** Caller requests last record
      *
     C                   IF        P@Optn = '*LAST  '
     C     *HIVAL        SETGT     SDDSTCL1                             90
     C                   IF        *IN90
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      P@Optn = '*PREV  '
     C                   ENDIF
      *
      ** Caller requests previous record
      *
     C                   IF        P@Optn = '*PREV  '
     C                   READP     SDDSTCL1                             9094
     C                   IF        *IN90 or *IN94
     C                   EXSR      SRReturn
     C                   ELSE
     C                   EVAL      DSFDY = SDDSTC
     C                   ENDIF
     C                   ENDIF
      *
      ** Caller requests record indicated by key
      *
     C                   IF        P@Optn = '*KEY   ' OR P@Optn = '*VERIFY'
      *
      ** Call for "?" on main screen
     C                   EVAL      WPos = %SCAN('?':P@DSTC)
      *
     C                   IF        WPos <> *ZEROS
     C                   CALL      'SD001006S'                          98
     C                   PARM                    P@RtCd2
     C                   PARM                    P@DSTC2
     C                   PARM                    P@DSTY2
      *
     C                   IF        P@RtCd2 <> *BLANKS
     C                   EVAL      *IN97 = *ON
     C                   ELSE
     C                   EVAL      P@DSTC = P@DSTC2
     C                   EVAL      P@DSTY = P@DSTY2
     C                   ENDIF
      *
     C                   IF        *IN98 OR *IN97
     C                   EXSR      SRReturn
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     Key1          CHAIN     SDDSTCL1                           9590
     C                   IF        *IN90 OR *IN95
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF            P@Optn <> '*KEY   '
     C                             AND P@OPTN <> '*NEXT  '
     C                             AND P@OPTN <> '*PREV  '
     C                             AND P@OPTN <> '*VERIFY'
     C                             AND P@OPTN <> '*FREE  '
     C                   EVAL      *IN96 = *ON
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
     C                   EVAL      P@RtCd = *BLANKS
      *
     C                   SELECT
     C                   WHEN      *IN90 = *ON
     C                   EVAL      P@RtCd = '*ERROR '
     C                   EVAL      *INLR = *ON
      *
     C                   WHEN      *IN91 = *ON
     C                   EVAL      P@RtCd = '*OPEN  '
     C                   EVAL      *INLR = *ON
      *
     C                   WHEN      *IN92 = *ON
     C                   EVAL      P@RtCd = '*CLOSE '
     C                   EVAL      *INLR = *ON
      *
     C                   WHEN      *IN93 = *ON
     C                   EVAL      P@RtCd = '*EMPTY '
      *
     C                   WHEN      *IN94 = *ON
     C                   EVAL      P@RtCd = '*EOF   '
      *
     C                   WHEN      *IN95 = *ON
     C                   EVAL      P@RtCd = '*NRF   '
      *
     C                   WHEN      *IN96 = *ON
     C                   EVAL      P@RtCd = '*OPTION'
      *
     C                   ENDSL
      *
      ** Caller requests message sent to program queue
      *
     C                   IF        W@RtCd = '*MSG   ' OR P@RtCd <> *BLANKS
      *
     C                   SELECT
     C                   WHEN      *IN90 = *ON
     C                   EVAL      P@MGID = 'ACO1001'
      *
     C                   WHEN      *IN91 = *ON
     C                   EVAL      P@MGID = 'ACO1002'
      *
     C                   WHEN      *IN92 = *ON
     C                   EVAL      P@MGID = 'ACO1003'
      *
     C                   WHEN      *IN93 = *ON
     C                   EVAL      P@MGID = 'ACO1004'
      *
     C                   WHEN      *IN94 = *ON
     C                   EVAL      P@MGID = 'ACO1005'
      *
     C                   WHEN      *IN95 = *ON
     C**********         EVAL      P@MGID = 'ACO1006'                                       BUG21068
     C                   EVAL      P@MGID = 'ACO1053'                                       BUG21068
      *
     C                   WHEN      *IN96 = *ON
     C                   EVAL      P@MGID = 'ACO1007'
     C                   ENDSL
      *
     C                   CALLB     'ZASNMG'
     C                   PARM      *BLANKS       W@RtCd
     C                   PARM      PSProcName    P@PgNm
     C                   PARM      '*PRV'        P@Dest
     C                   PARM                    P@MgId
     C                   PARM      *BLANKS       P@MsgF
     C                   PARM      *BLANKS       P@MgKy
     C                   PARM                    P@MgDt
     C                   PARM      '*DIAG'       P@MgTp
      *
     C                   ENDIF
      *
      ** Caller requests DB Handling
      *
     C                   IF        W@RtCd = '*DBERR ' AND P@RtCd <> *BLANKS
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
      *
     C                   IF            P@Optn <> '*VERIFY'
     C                             AND P@Optn <> '*FREE  '
     C                             AND P@RtCd <> '*OPTION'
     C                   EVAL      DSFDY = SDDSTC
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
     C     SrInit        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     Cpy@          Cpy2@            80
      *
      ** Receive entry parameters
      *
     C     *Entry        PLIST
     C     W@RtCd        PARM                    P@RtCd
     C                   PARM                    P@Optn
     C                   PARM                    P@DSTC
     C                   PARM                    P@DSTY
     C                   PARM      SDDSTC        DSFDY
      *
      ** Initialise Key Lists
      *
     C     Key1          KLIST
     C                   KFLD                    P@DSTC
     C                   KFLD                    P@DSTY
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2008
