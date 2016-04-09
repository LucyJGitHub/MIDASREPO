     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Collateral & Credit Ctl ICD access object')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  AOCOCCR0 - Collateral and Credit Control ICD access object   *
      *                                                               *
      *  Function:  This program will access the Collateral and       *
      *             Credit Control Details                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG3644            Date 12Jul04               *
      *  Prev Amend No. CLE025  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CLE025 - Credit Lines                                        *
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
      *    96         Option Error                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRReturn - Return Error Code and Set Parameters              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Collateral and Credit Control ICD file
     FSDCOCCL0  IF   E           K DISK    USROPN
 
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
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
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
 
      ** File information data structure
     D D_RFMT        E DS                  EXTNAME(SDCOCCPD)
 
      ** External data structure to hold the outgoing record format
     D P_RFMT        E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRetCode        S              7
     D POption         S              7
     D PPgmName        S             10
     D PDestQ          S              5
     D PMsgID          S              7
     D PMsgFile        S             10
     D PKeyVar         S              4
     D PMsgData        S             50
     D PMsgType        S              7
     D WRetCode        S              7
 
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
 
      ** Receive entry parameters
 
     C     *ENTRY        PLIST
     C     WRetCode      PARM                    PRetCode
     C                   PARM                    POption
     C                   PARM      D_RFMT        P_RFMT
 
      ** Initialise error indicators
 
     C                   EVAL      *IN90 = *OFF
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN96 = *OFF
 
      ** First call - open file - read record - close file
      ** Subsequent calls will return the format
 
     C                   IF        POption = '*FIRST '  OR
     C                             POption = '*NEXT  '  OR
     C                             POption = '*PREV  '  OR
     C                             POption = '*LAST  '  OR
     C                             POption = '*KEY   '  OR
     C                             POption = '*SAME  '  OR
     C                             POption = '*VERIFY'
 
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN01 = *ON
 
     C                   OPEN      SDCOCCL0                             91
 
     C                   IF        *IN91 = *ON
     C                   EVAL      *INLR = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
 
     C     *LOVAL        SETLL     SDCOCCL0                           9390
 
     C                   IF        *IN93 = *OFF
     C                   READ      SDCOCCL0                               93
     C                   ENDIF
 
     C                   CLOSE     SDCOCCL0                             92
 
     C                   IF        *IN93 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
 
     C                   IF        *IN90 = *ON
     C                   EVAL      *INLR = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
 
     C                   IF        *IN92
     C                   EVAL      *INLR = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        POption = '*FREE  '
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   EVAL      *IN96 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
 
     C                   ENDIF
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReturn - Return Error Code and Set Parameters              *
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
 
     C     *IN96         WHENEQ    *ON
     C                   EVAL      PRetCode = '*OPTION'
     C                   ENDSL
 
      ** Caller requests message sent to program queue
 
     C                   IF        WRetCode = '*MSG   '  AND  PRetCode <> *BLANKS
 
     C                   SELECT
     C     *IN90         WHENEQ    *ON
     C                   EVAL      PMsgID = 'ACO1001'
     C     *IN91         WHENEQ    *ON
     C                   EVAL      PMsgID = 'ACO1002'
     C     *IN92         WHENEQ    *ON
     C                   EVAL      PMsgID = 'ACO1003'
     C     *IN93         WHENEQ    *ON
     C                   EVAL      PMsgID = 'ACO1004'
     C     *IN96         WHENEQ    *ON
     C                   EVAL      PMsgID = 'ACO1007'
     C                   ENDSL
 
     C                   CALLB     'ZASNMG'
     C                   PARM      *BLANKS       WRetCode
     C                   PARM      'AOCOCCR0'    PPgmName
     C                   PARM      '*PRV'        PDestQ
     C                   PARM                    PMsgID
     C                   PARM      *BLANKS       PMsgFile
     C                   PARM      *BLANKS       PKeyVar
     C                   PARM                    PMsgData
     C                   PARM      '*DIAG'       PMsgType
 
     C                   ENDIF
 
      ** Caller Requests DB Error Handling
 
     C                   IF        WRetCode = '*DBERR '  AND  PRetCode <> *BLANKS
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
