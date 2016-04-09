     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Margin Schedule Types Access Object')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  AOMASTR0 - FX Margin Types       Access Object               *
      *                                                               *
      *  Function:  This program will access the FX Margin Types file *
      *             SDMASTPD                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG3644            Date 12Jul04               *
      *  Prev Amend No. CFX001  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CFX001 - FX Margin Trading                                   *
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
      *    98         Error on call of selection program (SD000750)   *
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
 
     FSDMASTL1  IF   E           K DISK    USROPN
      ** FX Margin Types File
 
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
     D SDMAST        E DS                  EXTNAME(SDMASTPD)
 
      ** External data structure to hold the outgoing record format
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Data structure for record selection
     D PMAST           DS
     D  WMAST1                 1      1
     D  WMAST2                 2      2
     D  WMAST3                 3      3
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRetCode        S              7
     D POption         S              7
     D PRTCD           S              7
     D PMODE           S              1
     D W_RTCD          S              7
     D P_PGNM          S             10
     D P_DEST          S              5
     D P_MGID          S              7
     D P_MGSF          S             10
     D P_MGKY          S              4
     D P_MGDA          S             50
     D P_MGTP          S              7
 
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
     C     W_RTCD        PARM                    PRetCode
     C                   PARM                    POption
     C                   PARM                    PMAST
     C                   PARM                    DSFDY
 
      ** Initialise return parameter
 
     C                   IF        POption = '*SAME  '
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
     C                   OPEN      SDMASTL1                             91
     C                   IF        *IN91
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
 
      ** Last call - close file and terminate program
 
     C                   IF        POption = '*FREE  '
     C                   CLOSE     SDMASTL1                             92
 
      ** If error in closing file
 
     C                   IF        *IN92
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
      ** If Option is *FIRST
 
     C                   IF        POption = '*FIRST '
     C     *LOVAL        SETLL     SDMASTL1                           9390
     C                   IF        *IN93 OR *IN90
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      POption = '*NEXT  '
     C                   ENDIF
 
      ** If option is *NEXT
 
     C                   IF        POption = '*NEXT  '
     C                   READ      SDMASTL1                             9094
     C                   IF        *IN94 or *IN90
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
 
      ** If Option is *LAST
 
     C                   IF        POption = '*LAST  '
     C     *HIVAL        SETGT     SDMASTL1                             90
     C                   IF        *IN90
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      POption = '*PREV  '
     C                   ENDIF
 
      ** If Option is *PREV
 
     C                   IF        POption = '*PREV  '
     C                   READP     SDMASTL1                             9094
     C                   IF        *IN94 OR *IN90
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
 
      ** If Option is *KEY or Option is *VERIFY
 
     C                   IF        (POption = '*KEY   ')  OR
     C                             (POption = '*VERIFY')
 
     C                   IF        WMAST1 = '?' OR
     C                             WMAST2 = '?' OR
     C                             WMAST3 = '?'
 
     C                   CALLB     'SD000750'                           98
     C                   PARM                    PRTCD
     C                   PARM      '?'           PMODE
     C                   PARM      *BLANKS       PMAST
 
     C                   IF        *IN98 = *ON
     C                   EXSR      SRReturn
     C                   ELSE
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      *IN97 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Access SDMASTL1
 
     C     PMAST         CHAIN     SDMASTL1                           9590
     C                   IF        *IN95 OR *IN90
     C                   EXSR      SRReturn
     C                   ENDIF
 
     C                   ENDIF
 
      ** If parameter error
 
     C                   IF        (POption <> '*KEY   ')  AND
     C                             (POption <> '*NEXT  ')  AND
     C                             (POption <> '*PREV  ')  AND
     C                             (POption <> '*VERIFY')  AND
     C                             (POption <> '*SAME  ')  AND
     C                             (POption <> '*FREE  ')
     C                   EVAL      *IN96 = *ON
     C                   ENDIF
 
     C                   EXSR      SRReturn
 
      *****************************************************************
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
 
     C                   EVAL      PRetCode = *BLANKS
 
     C                   SELECT
     C     *IN90         WHENEQ    *ON
     C                   EVAL      PRetCode = '*ERROR '
     C                   EVAL      *INLR = *ON
 
     C     *IN91         WHENEQ    *ON
     C                   EVAL      PRetCode = '*OPEN  '
     C                   EVAL      *INLR = *ON
 
     C     *IN92         WHENEQ    *ON
     C                   EVAL      PRetCode = '*CLOSE '
     C                   EVAL      *INLR = *ON
 
     C     *IN93         WHENEQ    *ON
     C                   EVAL      PRetCode = '*EMPTY '
 
     C     *IN94         WHENEQ    *ON
     C                   EVAL      PRetCode = '*EOF   '
 
     C     *IN95         WHENEQ    *ON
     C                   EVAL      PRetCode = '*NRF   '
 
     C     *IN96         WHENEQ    *ON
     C                   EVAL      PRetCode = '*OPTION'
 
     C     *IN97         WHENEQ    *ON
     C                   EVAL      PRetCode = '*NOSEL '
 
     C     *IN98         WHENEQ    *ON
     C                   EVAL      PRetCode = '*CALL  '
     C                   ENDSL
 
      ** Caller requests message sent to program queue
 
     C                   IF        (W_RTCD = '*MSG   ')  AND
     C                             (PRetCode <> *Blanks)
 
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
     C                   PARM      'AOMASTR0'    P_PGNM
     C                   PARM      '*PRV'        P_DEST
     C                   PARM                    P_MGID
     C                   PARM      *BLANKS       P_MGSF
     C                   PARM      *BLANKS       P_MGKY
     C                   PARM                    P_MGDA
     C                   PARM      '*DIAG'       P_MGTP
 
     C                   ENDIF
 
      ** Caller Requests DB Error Handling
 
     C                   IF        (W_RTCD = '*DBERR ')  AND
     C                             (PRetCode <> *BLANKS)
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   IF        POption <> '*VERIFY' AND
     C                             POption <> '*FREE  ' AND
     C                             POption <> '*OPTION'
     C                   EVAL      DSFDY = SDMAST
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
