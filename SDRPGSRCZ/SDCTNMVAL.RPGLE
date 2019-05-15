     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('SD Currency/Time of Netting Details Validate')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCTNMVAL - Currency/Time of Netting Details Validation      *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD021813           Date 28Aug13               *
      *                 AR1086546 *CREATE  Date 14Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD021813 - BankFusion_FX Netting:CDL025 Missing Menu Options *
      *  AR1086546 - Upgrade of CDL025 to MP1.4 (Child: AR1086547).   *
      *              Applied for MD021813                             *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDCTNML1  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **------------------------------------------------------------------
 
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
 
      ** Transaction Details in screen format
     D TrnDets       E DS                  EXTNAME(SDCCTNPD)
 
      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDECTNMPD)
 
      ** Valid Transaction Details layout
     D ValidCTNM     E DS                  EXTNAME(SDVCTNMPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Currency Details file
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
     D DSTime          DS
     D  W#Hrs                         2
     D  W#Mns                         2
 
      ** CTNM Currency 1 Array
     D Ccy1_Arr        S              3    DIM(10)
 
      ** CTNM Currency 2 Array
     D Ccy2_Arr        S              3    DIM(10)
 
      ** CTNM Time Array
     D Time_Arr        S              4    DIM(10)
 
      ** CTNM Release Notes Array
     D RNTD_Arr        S              1  0 DIM(10)
 
      ** Array of TIME for validation
     D ARTime          S              1A   DIM(5)
 
      ** array for CCY1 OK
     D DDCCY1_OKA      S              1    DIM(10)
     D DDCCY2_OKA      S              1    DIM(10)
     D DDTIME_OKA      S              1    DIM(10)
     D DDRNTD_OKA      S              1    DIM(10)
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work fields for bank data
     D WKDFIN          S                   LIKE(BJDFIN)
     D WKRDNB          S                   LIKE(BJRDNB)
     D WKCYCD          S                   LIKE(BJCYCD)
 
      ** Define Work Fields
     D W#Cnt           S              5S 0
     D W#LRcd          S              4S 0
     D W#SfPg          S              3S 0 Inz(12)
     D W#2S0           S              2S 0
     D X               S              1S 0
     D SLCCY1          S                   Like(DDCCY1_1)
     D SLCCY2          S                   Like(DDCCY2_2)
     D SLRNTD          S                   Like(DDRNTD_1)
     D SLTIME          S                   Like(DDTIME_2)
     D W#TXND          S              1P 0
     D W#PMD           S              3
     D W#IPin          S              1
     D W#RSF           S              1
     D W#Eror          S              1
     D W#Error         S              1
 
      ** Define Key Fields
     D K#LCUST         S                   Like(LCUST)
     D K#LCCY1         S                   Like(LCCY1)
     D K#LCCY2         S                   Like(LCCY2)
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
     D Ctr             S              3P 0
     D Z               S              3P 0
     D Idx1            S              3P 0
     D I               S              3P 0
 
      ** Entry parameters
     D RespMode        S              1A
 
     D CDL025          S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Clear all arrays
 
     C                   EXSR      Clear_Arr
 
      ** Populate Currency and Time Netting Arrays
 
     C                   EXSR      Pop_CtnSet
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Currency/Time Netting Array details
 
     C                   Eval      Ctr = 1
     C                   Eval      Idx1 = 0
     C                   DOW       Ccy1_Arr(Ctr)<>*BLANKS AND Ctr < 11
 
     C                   EVAL      SLCCY1=Ccy1_Arr(Ctr)
     C                   EVAL      SLCCY2=Ccy2_Arr(Ctr)
     C                   EVAL      SLRNTD=RNTD_Arr(Ctr)
     C                   EVAL      SLTIME=Time_Arr(Ctr)
 
     C                   EXSR      SRValidate
 
     C                   Eval      Ctr = Ctr + 1
 
     C                   If        Ctr = 11
     C                   Leave
     C                   EndIf
 
     C                   ENDDO
 
     C                   IF        Idx>0
     C                   EXSR      UPDATERRS
     C                   EndIf
 
      ** Populate OK fields from the arrays
 
     C                   EXSR      Pop_CtnSetOK
 
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate - Validate Input Fields                           *
      *                                                               *
      *****************************************************************
     C     SRValidate    BEGSR
 
     C                   Z-ADD     Ctr           Z
 
      ** Validate Currency Code 1
 
     C                   Call      'AOCURRR0'
     C                   Parm      '       '     PRTCD             7
     C                   Parm      '*KEY   '     POPTN             7
     C                   Parm      SLCCY1        @CRKEY            3
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   If        PRTCD <> *BLANKS
     C                   MOVE      'N'           DDCCY1_OKA(Z)
     C                   ADD       1             Idx
     C                   MOVEL     'DDCCY1'      FldNamXAr(Idx)
     C                   MOVEL     'USR0235'     MsgIdXAr(Idx)
     C                   Else
     C                   Z-ADD     A6TXND        W#TXND
     C                   EndIf
 
      ** Validate Currency Code 2
 
     C                   If        SLCCY2 <> *BLANKS
 
      ** Validate Currency Code 2
 
     C                   Call      'AOCURRR0'
     C                   Parm      '       '     PRTCD             7
     C                   Parm      '*KEY   '     POPTN             7
     C                   Parm      SLCCY2        @CRKEY            3
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   If        PRTCD <> *BLANKS
     C                   MOVE      'N'           DDCCY2_OKA(Z)
     C                   ADD       1             Idx
     C                   MOVEL     'DDCCY2'      FldNamXAr(Idx)
     C                   MOVEL     'USR0235'     MsgIdXAr(Idx)
     C                   EndIf
     C                   EndIf
 
      ** Validate Notice Days
      ** Valid Value 0-9
 
     C     SLRNTD        IFLT      0
     C     SLRNTD        ORGT      9
     C                   MOVE      'N'           DDRNTD_OKA(Z)
     C                   ADD       1             Idx
     C                   MOVEL     'DDRNTD'      FldNamXAr(Idx)
     C**********         MOVEL     'USR4596'     MsgIdXAr(Idx)                              MD021813
     C                   MOVEL     '5046098'     MsgIdXAr(Idx)                              MD021813
     C                   EndIf
 
      ** Notice days must be < Telex days
 
     C     SLRNTD        IFGT      W#TXND
     C                   MOVE      'N'           DDRNTD_OKA(Z)
     C                   ADD       1             Idx
     C                   MOVEL     'DDRNTD'      FldNamXAr(Idx)
     C***********        MOVEL     'USR4596'     MsgIdXAr(Idx)                              MD021813
     C                   MOVEL     '5046098'     MsgIdXAr(Idx)                              MD021813
     C                   EndIf
 
      ** Validate Time
      *** Blanks is Valid 'Catch All' for COB
      *
     C                   If        SLTIME <> *Blanks
     C                   Eval      W#Error = 'N'
     C                   Eval      X = 0
     C                   MoveA     SLTIME        ARTIME
     C                   DoU       X = 5
     C                   Eval      X = X + 1
     C                   If        ARTIME(X) < '0' or ARTIME(X) >'9'
     C                   Select
      ** InValid - Ok If 3rd char and a colon
     C                   When      X = 3 and ARTIME(X) = ':'
 
      ** If its 5th char is Blank and 3rd is not : Ok
     C                   When      X = 5 and
     C                             ARTIME(3) <> ':' and ARTIME(5) = ' '
 
     C                   Other
     C                   Eval      W#Error = 'Y'
     C                   Leave
 
     C                   EndSl
     C                   EndIf
     C                   EndDo
 
     C                   If        W#Error = 'N' and
     C                             ARTIME(3) <> ':' and ARTIME(5) <> ' '
     C                   Eval      W#Error = 'Y'
     C                   EndIF
 
      ** Set up time fields for file
 
     C                   If        W#Error <> 'Y'
     C                   Eval      W#Hrs = ARTime(1) + ARTime(2)
     C                   If        ARTime(3) <> ':'
     C                   Eval      W#Mns = ARTime(3) + ARTime(4)
     C                   Else
     C                   Eval      W#Mns = ARTime(4) + ARTime(5)
     C                   Endif
 
      ** Valid Hours ?
 
     C                   Move      W#Hrs         W#2S0
     C                   If        W#2S0 < 7 or W#2S0 > 19
     C                   Eval      W#Error = 'Y'
     C                   Endif
     C                   Endif
 
      ** Valid Mins ?
 
     C                   If        W#Error <> 'Y' and
     C                             W#Mns <> '00' and W#Mns <> '30'
     C                   Eval      W#Error = 'Y'
     C                   Endif
 
      ** Valid time
 
     C                   If        W#Hrs = '19' and W#Mns <> '00'
     C                   Eval      W#Error = 'Y'
     C                   Endif
 
     C                   If        W#Error = 'Y'
     C                   MOVE      'N'           DDTIME_OKA(Z)
     C                   ADD       1             Idx
     C                   MOVEL     'DDTIME'      FldNamXAr(Idx)
     C**********         MOVEL     'USR4597'     MsgIdXAr(Idx)                              MD021813
     C                   MOVEL     '5046101'     MsgIdXAr(Idx)                              MD021813
     C                   EndIf
 
     C                   EndIf
 
     C     DDACTN        IFEQ      'I'
     C     DDCCY1_OKA(Z) ANDEQ     'Y'
     C     DDCCY2_OKA(Z) ANDEQ     'Y'
     C     DDRNTD_OKA(Z) ANDEQ     'Y'
     C     DDTIME_OKA(Z) ANDEQ     'Y'
 
      ** Access Currency/Time of Netting Details
      ** Check for duplicate primary key
 
     C                   Eval      K#LCUST = DDCUST
     C                   Eval      K#LCCY1 = SLCCY1
     C                   Eval      K#LCCY2 = SLCCY2
 
     C     CTKEY         CHAIN     SDCTNML1                           99
     C                   IF        *IN99 = *OFF
     C                   MOVE      'N'           DDCCY1_OKA(Z)
     C                   ADD       1             Idx
     C                   MOVEL     'DDCCY1'      FldNamXAr(Idx)
     C**********         MOVEL     'USR4598'     MsgIdXAr(Idx)                              MD021813
     C                   MOVEL     '5046104'     MsgIdXAr(Idx)                              MD021813
     C                   EndIf
 
     C                   EndIf
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *                                                               *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
 
      ** Reset error & warning fields/message IDs/message data (arrays)
 
     C                   EVAL      FldNamXAr = *BLANK
     C                   EVAL      MsgIDXAr  = *BLANK
     C                   EVAL      MsgDtaXAr = *BLANK
     C                   EVAL      WFldNmXAr = *BLANK
     C                   EVAL      WMsgIDXAr = *BLANK
     C                   EVAL      WMsgDtXAr = *BLANK
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATERRS - Update error information with that received back  *
      *             from each validation.                             *
      *                                                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
 
      ** Set Warning Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Clear_Arr - Subroutine for clearing code & set id arrays     *
      *                                                               *
      *****************************************************************
     C     Clear_Arr     BEGSR
 
     C                   Clear                   Ccy1_Arr
     C                   Clear                   Ccy2_Arr
     C                   Clear                   Time_Arr
     C                   Clear                   RNTD_Arr
     C                   MOVE      *ALL'Y'       DDCCY1_OKA
     C                   MOVE      *ALL'Y'       DDCCY2_OKA
     C                   MOVE      *ALL'Y'       DDTIME_OKA
     C                   MOVE      *ALL'Y'       DDRNTD_OKA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Pop_CtnSet - Subroutine for Time of Nettiing array population*
      *                                                               *
      *****************************************************************
     C     Pop_CtnSet    BEGSR
 
     C                   Eval      Ccy1_Arr(1) = DDCCY1_1
     C                   Eval      Ccy2_Arr(1) = DDCCY2_1
     C                   Eval      Time_Arr(1) = DDTIME_1
     C                   Eval      Rntd_Arr(1) = DDRNTD_1
     C                   Eval      Ccy1_Arr(2) = DDCCY1_2
     C                   Eval      Ccy2_Arr(2) = DDCCY2_2
     C                   Eval      Time_Arr(2) = DDTIME_2
     C                   Eval      Rntd_Arr(2) = DDRNTD_2
     C                   Eval      Ccy1_Arr(3) = DDCCY1_3
     C                   Eval      Ccy2_Arr(3) = DDCCY2_3
     C                   Eval      Time_Arr(3) = DDTIME_3
     C                   Eval      Rntd_Arr(3) = DDRNTD_3
     C                   Eval      Ccy1_Arr(4) = DDCCY1_4
     C                   Eval      Ccy2_Arr(4) = DDCCY2_4
     C                   Eval      Time_Arr(4) = DDTIME_4
     C                   Eval      Rntd_Arr(4) = DDRNTD_4
     C                   Eval      Ccy1_Arr(5) = DDCCY1_5
     C                   Eval      Ccy2_Arr(5) = DDCCY2_5
     C                   Eval      Time_Arr(5) = DDTIME_5
     C                   Eval      Rntd_Arr(5) = DDRNTD_5
     C                   Eval      Ccy1_Arr(6) = DDCCY1_6
     C                   Eval      Ccy2_Arr(6) = DDCCY2_6
     C                   Eval      Time_Arr(6) = DDTIME_6
     C                   Eval      Rntd_Arr(6) = DDRNTD_6
     C                   Eval      Ccy1_Arr(7) = DDCCY1_7
     C                   Eval      Ccy2_Arr(7) = DDCCY2_7
     C                   Eval      Time_Arr(7) = DDTIME_7
     C                   Eval      Rntd_Arr(7) = DDRNTD_7
     C                   Eval      Ccy1_Arr(8) = DDCCY1_8
     C                   Eval      Ccy2_Arr(8) = DDCCY2_8
     C                   Eval      Time_Arr(8) = DDTIME_8
     C                   Eval      Rntd_Arr(8) = DDRNTD_8
     C                   Eval      Ccy1_Arr(9) = DDCCY1_9
     C                   Eval      Ccy2_Arr(9) = DDCCY2_9
     C                   Eval      Time_Arr(9) = DDTIME_9
     C                   Eval      Rntd_Arr(9) = DDRNTD_9
     C                   Eval      Ccy1_Arr(10) = DDCCY1_10
     C                   Eval      Ccy2_Arr(10) = DDCCY2_10
     C                   Eval      Time_Arr(10) = DDTIME_10
     C                   Eval      Rntd_Arr(10) = DDRNTD_10
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Pop_CtnSetOK - Subroutine for OK Fields Population           *
      *                                                               *
      *****************************************************************
     C     Pop_CtnSetOK  BEGSR
 
     C                   Eval      DDCCY1_1OK = DDCCY1_OKA(1)
     C                   Eval      DDCCY2_1OK = DDCCY2_OKA(1)
     C                   Eval      DDTIME_1OK = DDTIME_OKA(1)
     C                   Eval      DDRNTD_1OK = DDRNTD_OKA(1)
     C                   Eval      DDCCY1_2OK = DDCCY1_OKA(2)
     C                   Eval      DDCCY2_2OK = DDCCY2_OKA(2)
     C                   Eval      DDTIME_2OK = DDTIME_OKA(2)
     C                   Eval      DDRNTD_2OK = DDRNTD_OKA(2)
     C                   Eval      DDCCY1_3OK = DDCCY1_OKA(3)
     C                   Eval      DDCCY2_3OK = DDCCY2_OKA(3)
     C                   Eval      DDTIME_3OK = DDTIME_OKA(3)
     C                   Eval      DDRNTD_3OK = DDRNTD_OKA(3)
     C                   Eval      DDCCY1_4OK = DDCCY1_OKA(4)
     C                   Eval      DDCCY2_4OK = DDCCY2_OKA(4)
     C                   Eval      DDTIME_4OK = DDTIME_OKA(4)
     C                   Eval      DDRNTD_4OK = DDRNTD_OKA(4)
     C                   Eval      DDCCY1_5OK = DDCCY1_OKA(5)
     C                   Eval      DDCCY2_5OK = DDCCY2_OKA(5)
     C                   Eval      DDTIME_5OK = DDTIME_OKA(5)
     C                   Eval      DDRNTD_5OK = DDRNTD_OKA(5)
     C                   Eval      DDCCY1_6OK = DDCCY1_OKA(6)
     C                   Eval      DDCCY2_6OK = DDCCY2_OKA(6)
     C                   Eval      DDTIME_6OK = DDTIME_OKA(6)
     C                   Eval      DDRNTD_6OK = DDRNTD_OKA(6)
     C                   Eval      DDCCY1_7OK = DDCCY1_OKA(7)
     C                   Eval      DDCCY2_7OK = DDCCY2_OKA(7)
     C                   Eval      DDTIME_7OK = DDTIME_OKA(7)
     C                   Eval      DDRNTD_7OK = DDRNTD_OKA(7)
     C                   Eval      DDCCY1_8OK = DDCCY1_OKA(8)
     C                   Eval      DDCCY2_8OK = DDCCY2_OKA(8)
     C                   Eval      DDTIME_8OK = DDTIME_OKA(8)
     C                   Eval      DDRNTD_8OK = DDRNTD_OKA(8)
     C                   Eval      DDCCY1_9OK = DDCCY1_OKA(9)
     C                   Eval      DDCCY2_9OK = DDCCY2_OKA(9)
     C                   Eval      DDTIME_9OK = DDTIME_OKA(9)
     C                   Eval      DDRNTD_9OK = DDRNTD_OKA(9)
     C                   Eval      DDCCY110OK = DDCCY1_OKA(10)
     C                   Eval      DDCCY210OK = DDCCY2_OKA(10)
     C                   Eval      DDTIME10OK = DDTIME_OKA(10)
     C                   Eval      DDRNTD10OK = DDRNTD_OKA(10)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Response mode
 
     C                   PARM                    RespMode
 
      ** Currency/Time of Netting Details
 
     C                   PARM                    TrnDets
 
      ** Outputs
      ** Currency/Time of Netting Details OK inds
 
     C                   PARM                    OKTrnDets
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WIdx
 
      ** Valid Currency/Time of Nettingd details layout (DS) from/to caller
 
     C                   PARM                    ValidCTNM
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  =  900
     C                   EVAL      DBKEY  = @OPTN
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WKDFIN = BJDFIN
     C                   EVAL      WKRDNB = BJRDNB
     C                   EVAL      WKCYCD = BJCYCD
     C                   ENDIF
 
      ** Check if switchable feature CDL025 is switched on.
      ** Currency/Time of Netting Maintenance
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL025'      @SARD
 
      ** Database Error
 
     C                   IF        @RTCD <> *BLANKS AND
     C                             @RTCD <> '*NRF   '
     C                   EVAL      DBKEY  = 'CDL025'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  =  902
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RTCD = *BLANK
     C                   MOVE      'Y'           CDL025
     C                   ELSE
     C                   MOVE      'N'           CDL025
     C                   ENDIF
      *
     C     CTKEY         KList
     C                   KFld                    K#LCUST
     C                   KFld                    K#LCCY1
     C                   KFld                    K#LCCY2
      *
      *****************************************************************
      /EJECT
      **------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      **------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2013
