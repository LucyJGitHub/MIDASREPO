     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Hedge Linkage Tables Access Object')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  AOHGLKR0 - Hedge Linkage Tables Access Object                *
      *                                                               *
      *  Function:  This program will access the Hedge Linkage        *
      *             Tables LF/ASHGLKL1                                *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CAS002  *CREATE    Date 14Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAS002 - Hedge Strategy/Linkage                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Open File                                       *
      *    90         File Error                                      *
      *    91         Open Error                                      *
      *    92         Close Error                                     *
      *    93         Empty File                                      *
      *    94         End of File                                     *
      *    95         No Record found                                 *
      *    96         Option Error                                    *
      *    97         No selection                                    *
      *    98         Error on call of selection program (AS000001)   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR        -  Program Initialisation Routine              *
      *  SRReturn      -  Return Error Code and Set Parameters        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FASHGLKL1  IF   E           K DISK    USROPN
      ** Hedge Linkage Tables Master File Retrieval Index
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
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
 
      ** File information data structure
     D D_RFMT        E DS                  EXTNAME(ASHGLKPD)
 
      ** External data structure to hold the outgoing record format
     D P_RFMT        E DS                  EXTNAME(DSSDY)
 
      ** Data structure for record selection
     D P_HGLK          DS
     D  W_HDG1                 1      1
     D  W_HDG2                 2      2
     D  W_HDG3                 3      3
     D  W_HDG4                 4      4
     D  W_HDG5                 5      5
     D  W_HDG6                 6      6
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D P_RTCD          S              7
     D P_OPTN          S              7
     D P_RCODE         S              7
     D P_MODE          S              1
     D W_RTCD          S              7
     D P_PGNM          S             10
     D P_DEST          S              5
     D P_MGID          S              7
     D P_MGSF          S             10
     D P_MGKY          S              4
     D P_MGDA          S             50
     D P_MGTP          S              7
     D P_TEMP          S              6  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Receive entry parameter
 
     C     *ENTRY        PLIST
     C     W_RTCD        PARM                    P_RTCD
     C                   PARM                    P_OPTN
     C                   PARM                    P_HGLK
     C                   PARM                    P_RFMT
 
      ** Initialise return parameter
 
     C                   IF        P_OPTN = '*SAME  '
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN91 = *ON
     C                   ELSE
     C                   EVAL      *IN91 = *OFF
     C                   ENDIF
     C                   EXSR      SRReturn
     C                   ENDIF
 
      ** Initialise error indicators
 
     C                   EVAL      *IN90 = *OFF
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN94 = *OFF
     C                   EVAL      *IN95 = *OFF
     C                   EVAL      *IN96 = *OFF
     C                   EVAL      *IN97 = *OFF
     C                   EVAL      *IN98 = *OFF
 
      ** First call - open file
 
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN01 = *ON
     C                   OPEN      ASHGLKL1                             91
     C                   IF        *IN91
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
 
      ** Last call - close file and terminate program
 
     C                   IF        P_OPTN = '*FREE  '
     C                   CLOSE     ASHGLKL1                             92
 
      ** If error in closing file
 
     C                   IF        *IN92
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
      ** If Option is *FIRST
 
     C                   IF        P_OPTN = '*FIRST '
     C     *LOVAL        SETLL     ASHGLKL1                           9390
     C                   IF        *IN93 OR *IN90
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      P_OPTN = '*NEXT  '
     C                   ENDIF
 
      ** If option is *NEXT
 
     C                   IF        P_OPTN = '*NEXT  '
     C                   READ      ASHGLKL1                             9094
     C                   IF        *IN94 or *IN90
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
 
      ** If Option is *LAST
 
     C                   IF        P_OPTN = '*LAST  '
     C     *HIVAL        SETGT     ASHGLKL1                             90
     C                   IF        *IN90
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      P_OPTN = '*PREV  '
     C                   ENDIF
 
      ** If Option is *PREV
 
     C                   IF        P_OPTN = '*PREV  '
     C                   READP     ASHGLKL1                             9094
     C                   IF        *IN94 OR *IN90
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
 
      ** If Option is *KEY or Option is *VERIFY
 
     C                   IF        (P_OPTN = '*KEY   ') OR
     C                             (P_OPTN = '*VERIFY')
 
     C                   IF        W_HDG1 = '?' OR
     C                             W_HDG2 = '?' OR
     C                             W_HDG3 = '?' OR
     C                             W_HDG4 = '?' OR
     C                             W_HDG5 = '?' OR
     C                             W_HDG6 = '?'
     C                   CALL      'AS000001'                           98
     C                   PARM                    P_RCODE
     C                   PARM      '?'           P_MODE
     C                   PARM      *BLANKS       P_HGLK
 
     C                   IF        *IN98 = *ON
     C                   EXSR      SRReturn
     C                   ELSE
     C                   IF        P_RCODE <> *Blanks
     C                   EVAL      *IN97 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Access ASHGLKL1
 
     C                   MOVE      P_HGLK        P_TEMP
 
     C     P_TEMP        CHAIN     ASHGLKL1                           9590
     C                   IF        *IN95 OR *IN90
     C                   EXSR      SRReturn
     C                   ENDIF
 
     C                   ENDIF
 
      ** If parameter error
 
     C                   IF        (P_OPTN <> '*KEY   ') AND
     C                             (P_OPTN <> '*NEXT  ') AND
     C                             (P_OPTN <> '*PREV  ') AND
     C                             (P_OPTN <> '*VERIFY') AND
     C                             (P_OPTN <> '*SAME  ') AND
     C                             (P_OPTN <> '*FREE  ')
     C                   EVAL      *IN96 = *ON
     C                   ENDIF
 
     C                   EXSR      SRReturn
 
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
 
     C     SRReturn      BEGSR
 
      ** Return Error Code
 
     C                   EVAL      P_RTCD = *BLANKS
 
     C                   SELECT
     C     *IN90         WHENEQ    *ON
     C                   EVAL      P_RTCD = '*ERROR '
     C                   EVAL      *INLR = *ON
     C     *IN91         WHENEQ    *ON
     C                   EVAL      P_RTCD = '*OPEN  '
     C                   EVAL      *INLR = *ON
     C     *IN92         WHENEQ    *ON
     C                   EVAL      P_RTCD = '*CLOSE '
     C                   EVAL      *INLR = *ON
     C     *IN93         WHENEQ    *ON
     C                   EVAL      P_RTCD = '*EMPTY '
     C     *IN94         WHENEQ    *ON
     C                   EVAL      P_RTCD = '*EOF   '
     C     *IN95         WHENEQ    *ON
     C                   EVAL      P_RTCD = '*NRF   '
     C     *IN96         WHENEQ    *ON
     C                   EVAL      P_RTCD = '*OPTION'
     C     *IN97         WHENEQ    *ON
     C                   EVAL      P_RTCD = '*NOSEL '
     C     *IN98         WHENEQ    *ON
     C                   EVAL      P_RTCD = '*CALL  '
     C                   ENDSL
 
      ** Caller requests message sent to program queue
 
     C                   IF        (W_RTCD = '*MSG   ') AND
     C                             (P_RTCD <> *Blanks)
 
     C                   SELECT
     C     *IN90         WHENEQ    *ON
     C                   EVAL      P_MGID = 'ACO1001'
     C     *IN91         WHENEQ    *ON
     C                   EVAL      P_MGID = 'ACO1002'
     C     *IN92         WHENEQ    *ON
     C                   EVAL      P_MGID = 'ACO1003'
     C     *IN93         WHENEQ    *ON
     C                   EVAL      P_MGID = 'ACO1004'
     C     *IN94         WHENEQ    *ON
     C                   EVAL      P_MGID = 'ACO1005'
     C     *IN95         WHENEQ    *ON
     C                   EVAL      P_MGID = 'ACO1006'
     C     *IN96         WHENEQ    *ON
     C                   EVAL      P_MGID = 'ACO1007'
     C     *IN97         WHENEQ    *ON
     C                   EVAL      P_MGID = 'ACO1009'
     C     *IN98         WHENEQ    *ON
     C                   EVAL      P_MGID = 'ACO1010'
     C                   ENDSL
 
     C                   CALL      'ZASNMG'
     C                   PARM      *BLANKS       W_RTCD
     C                   PARM      'AOHGLKR0'    P_PGNM
     C                   PARM      '*PRV'        P_DEST
     C                   PARM                    P_MGID
     C                   PARM      *BLANKS       P_MGSF
     C                   PARM      *BLANKS       P_MGKY
     C                   PARM                    P_MGDA
     C                   PARM      '*DIAG'       P_MGTP
 
     C                   ENDIF
 
      ** Caller Requests DB Error Handling
 
     C                   IF        (W_RTCD = '*DBERR ') AND
     C                             (P_RTCD <> *BLANK)
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   IF        P_OPTN <> '*VERIFY' AND
     C                             P_OPTN <> '*FREE  ' AND
     C                             P_OPTN <> '*OPTION'
     C                   EVAL      P_RFMT = D_RFMT
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
