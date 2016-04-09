     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Workstation Menu Details access object')
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOWMNUR0 - Work Station Menu Details access objects          *
      *                                                               *
      *  Function:  This module access details from SFWMNUPD          *
      *             with parameters of workstation code and other     *
      *             standard parameter (return code, option, etc.)    *
      *             Outputs the user profile and reroute flag and the *
      *             complete details of the record through DSSDY      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         OFF on the first run                            *
      *    20         File Error                                      *
      *    21         OPEN Error                                      *
      *    22         CLOSE Error                                     *
      *    23         Empty File                                      *
      *    24         End of File                                     *
      *    25         No Record found                                 *
      *    26         OPTION Error                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRReturn - Return Error Code and Set Parameters              *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Workstation Menu Details
     FSFWMNUL1  IF   E           K DISK    USROPN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
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
 
      **  Define parameter for msg program
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
 
      **  Define structure to hold values in SFWMNUPD.
     D D@FMT         E DS                  EXTNAME(SFWMNUPD)
 
      **  Define output parameter to hold values of SFWMNUPD
     D P@FMT         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **  Define parameters used
     D P@RTCD          S              7A
     D P@OPTN          S              7A
     D P@KEY           S             10A
     D P@PGNM          S             10A
     D P@DEST          S              5A
     D P@MGID          S              7A
     D P@MSGF          S             10A
     D P@MGKY          S              4A
     D P@MGTP          S              7A
 
      **  Define other variables
     D W@RTCD          S              7A
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      **  Main Program
      **  Initialization subroutine was implicitly performed already
 
      **  Initialise Return Parameter
 
     C                   IF        P@OPTN = '*SAME  '
     C                   IF        *IN01 = '0'
     C                   EVAL      *IN21 = '1'
     C                   ELSE
     C                   EVAL      *IN21 = '0'
     C                   ENDIF
     C                   EXSR      SRReturn
     C                   ENDIF
 
 
      **  Initialise Error Indicators
 
     C                   MOVEA     '0000000'     *IN(20)
 
 
      **  First call - open file
 
     C                   IF        *IN01 = '0'
     C                   EVAL      *IN01 = '1'
     C                   OPEN      SFWMNUL1                             21
     C                   IF        *IN21
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
 
 
      **  Last Call - Close File and terminate program
 
     C                   IF        P@OPTN = '*FREE  '
     C                   CLOSE     SFWMNUL1                             22
     C                   IF        *IN22
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      *INLR = '1'
     C                   ENDIF
 
 
      **  Caller requests first record
 
     C                   IF        P@OPTN = '*FIRST '
     C     *LOVAL        SETLL     SFWMNUD0                           2320
     C                   IF        *IN23 or *IN20
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      P@OPTN = '*NEXT  '
     C                   ENDIF
 
 
      **  Caller requests next record
 
     C                   IF        P@OPTN = '*NEXT  '
     C                   READ      SFWMNUD0                             2024
     C                   IF        *IN24 or *IN20
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
 
 
      **  Caller requests last record
 
     C                   IF        P@OPTN = '*LAST  '
     C     *HIVAL        SETGT     SFWMNUD0                             20
     C                   IF        *IN20
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      P@OPTN = '*PREV  '
     C                   ENDIF
 
 
      **  Caller requests previous record
 
     C                   IF        P@OPTN = '*PREV  '
     C                   READP     SFWMNUD0                             2024
     C                   IF        *IN24 or *IN20
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
 
 
      **  Caller requests record indicated by key
 
     C                   IF        P@OPTN = '*KEY   ' or P@OPTN = '*VERIFY'
 
     C     P@KEY         CHAIN     SFWMNUD0                           2520
 
     C                   IF        *IN25 or *IN20
     C                   EXSR      SRReturn
     C                   ENDIF
 
     C                   ENDIF
 
 
      **  Error in option passed as parameter
     C                   IF        P@OPTN <> '*KEY   '
     C                             and P@OPTN <> '*NEXT  '
     C                             and P@OPTN <> '*PREV  '
     C                             and P@OPTN <> '*VERIFY'
     C                             and P@OPTN <> '*FREE  '
     C                   EVAL      *IN26 = '1'
     C                   ENDIF
 
     C                   EXSR      SRReturn
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReturn - Return Error Code and Set Parameters              *
      *                                                               *
      *  Called by: Main Program                                      *
      *                                                               *
      *  Calls    : ZASNMG, DBERRCTL                                  *
      *                                                               *
      *****************************************************************
 
     C     SRReturn      BEGSR
 
      **  Return Error Code
 
     C                   EVAL      P@RTCD = *BLANKS
 
     C                   SELECT
     C     *IN20         WHENEQ    '1'
     C                   EVAL      P@RTCD = '*ERROR '
     C                   EVAL      *INLR = '1'
     C     *IN21         WHENEQ    '1'
     C                   EVAL      P@RTCD = '*OPEN  '
     C                   EVAL      *INLR = '1'
     C     *IN22         WHENEQ    '1'
     C                   EVAL      P@RTCD = '*CLOSE '
     C                   EVAL      *INLR = '1'
     C     *IN23         WHENEQ    '1'
     C                   EVAL      P@RTCD = '*EMPTY '
     C     *IN24         WHENEQ    '1'
     C                   EVAL      P@RTCD = '*EOF   '
     C     *IN25         WHENEQ    '1'
     C                   EVAL      P@RTCD = '*NRF   '
     C     *IN26         WHENEQ    '1'
     C                   EVAL      P@RTCD = '*OPTION'
     C                   ENDSL
 
 
      ** Caller requests message sent to program queue
 
     C                   IF        W@RTCD = '*MSG   ' and P@RTCD <> *BLANKS
 
     C                   SELECT
     C     *IN20         WHENEQ    '1'
     C                   EVAL      P@MGID = 'ACO1001'
     C     *IN21         WHENEQ    '1'
     C                   EVAL      P@MGID = 'ACO1002'
     C     *IN22         WHENEQ    '1'
     C                   EVAL      P@MGID = 'ACO1003'
     C     *IN23         WHENEQ    '1'
     C                   EVAL      P@MGID = 'ACO1004'
     C     *IN24         WHENEQ    '1'
     C                   EVAL      P@MGID = 'ACO1005'
     C     *IN25         WHENEQ    '1'
     C                   EVAL      P@MGID = 'ACO1006'
     C     *IN26         WHENEQ    '1'
     C                   EVAL      P@MGID = 'ACO1007'
     C                   ENDSL
 
     C                   CALLB     'ZASNMG'
     C                   PARM      *BLANKS       W@RTCD
     C                   PARM      PSProcName    P@PGNM
     C                   PARM      '*PRV'        P@DEST
     C                   PARM                    P@MGID
     C                   PARM      *BLANKS       P@MSGF
     C                   PARM      *BLANKS       P@MGKY
     C                   PARM                    P@MGDA
     C                   PARM      '*DIAG'       P@MGTP
 
     C                   ENDIF
 
      **  Caller requests DB Handling
 
     C                   IF        W@RTCD = '*DBERR ' and P@RTCD <> *BLANKS
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
      **  Pass the record back to caller.
     C     P@OPTN        IFNE      '*VERIFY'
     C     P@OPTN        ANDNE     '*FREE  '
     C     P@RTCD        ANDNE     '*OPTION'
     C                   MOVEL     D@FMT         P@FMT
     C                   ENDIF
 
      **  Ensure that the file is closed before return operation to
      **  avoid leaving the file open which may cause allocation
      **  problems in other applications.
     C                   IF        P@OPTN = '*VERIFY' OR P@OPTN = '*KEY   '
     C                   CLOSE     SFWMNUL1
     C                   ENDIF
 
      **  Return to caller
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      **  Receive entry parameters
 
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD
     C                   PARM                    P@OPTN
     C                   PARM                    P@KEY
     C                   PARM                    P@FMT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
** CPY@
(c) Misys International Banking Systems Ltd. 2001
** @MG
SFWMNUPD  AOWMNUR0  Work Station Menu Details
