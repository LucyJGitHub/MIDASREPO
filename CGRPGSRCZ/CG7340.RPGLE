     H DEBUG DATEDIT(*DMY)
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Interest Scale Historic Reporting')           *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG7340 - Interest Scale Report - Historic Reporting          *
      *                                                               *
      *  Called By: CGC7340                                           *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER042 *CREATE     Date 11May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179)                             *
      *                                                               *
      *---------------------------------------------------------------*
      *  Interest Scale Historic Print Request
     FCGISHPPD  IP   E             DISK
 
      ** Interest Scale Qualifying Account Codes file
     FCGISBQL0  IF   E           K DISK
 
      ** Data structure to split the from and to months
     D @EDATE          DS
     D  @ECC                   1      2  0
     D  @EYY                   3      4  0
     D  @EMM                   5      6  0
 
      ** Data structure to reconvene the from and to months
     D @ODATE          DS
     D  @ODD                   1      2  0
     D  @OMM                   3      4  0
     D  @OYY                   5      6  0
 
     D ZERR            S              7A
     D ZDATE           S              6  0
     D ZDATFM          S              1A
     D ZDAYNO          S              5  0
     D @PSTDT          S              5  0
     D @PENDT          S              5  0
      *
 
      ** Redefine the fields in the historic deals file
     ICGISRQD0
     I              Z6DLTP                      Z1DLTP
     I              Z6DLST                      Z1DLST
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  Main routine - main controling subroutine
      *
      *  Called by :  none
      *  Calls     :  None
      *
      *****************************************************************
      ** Find if the account code is qualifying account code
     C     Z2ACOD        CHAIN     CGISBQL0                           89
 
      ** If the account code is a qualifying account process further
     C     *IN89         IFEQ      *OFF
 
      ** Format the from month to convert to day number of first
      ** of the month
     C                   MOVE      Z2FMTH        @EDATE
     C                   Z-ADD     1             @ODD
     C                   Z-ADD     @EMM          @OMM
     C                   Z-ADD     @EYY          @OYY
     C                   MOVE      @ODATE        ZDATE
 
      ** Get the Midas day number
     C                   CALL      'ZDATE1'
     C                   PARM                    ZERR
     C                   PARM                    ZDATE
     C                   PARM                    ZDATFM
     C                   PARM                    ZDAYNO
 
      ** Move to start date
     C                   Z-ADD     ZDAYNO        @PSTDT
 
      ** If the to date was zeros use the last day of from month
     C     Z2LMTH        IFEQ      0
 
      ** Format the from month to convert to day number of first
      ** of the month
     C                   MOVE      Z2FMTH        @EDATE
     C                   Z-ADD     1             @ODD
     C     @EMM          ADD       1             @OMM
     C                   Z-ADD     @EYY          @OYY
 
      ** Cater for over the year end
     C     @OMM          IFGT      12
     C                   Z-ADD     1             @OMM
     C                   ADD       1             @OYY
     C                   ENDIF
     C                   MOVE      @ODATE        ZDATE
 
      ** Get the Midas day number
     C                   CALL      'ZDATE1'
     C                   PARM                    ZERR
     C                   PARM                    ZDATE
     C                   PARM                    ZDATFM
     C                   PARM                    ZDAYNO
     C     ZDAYNO        SUB       1             @PENDT
 
      ** If the from date entered
     C                   ELSE
 
      ** Format the To-month to convert to day number of first
      ** of the month
     C                   MOVE      Z2LMTH        @EDATE
     C                   Z-ADD     1             @ODD
     C                   Z-ADD     @EMM          @OMM
     C                   Z-ADD     @EYY          @OYY
     C                   MOVE      @ODATE        ZDATE
     C                   CALL      'ZDATE1'
     C                   PARM                    ZERR
     C                   PARM                    ZDATE
     C                   PARM                    ZDATFM
     C                   PARM                    ZDAYNO
     C                   Z-ADD     ZDAYNO        @PENDT
     C                   ENDIF
 
      ** Extract the dealing details using OPNQRYF and calling CG7200
     C                   CALL      'CGC7350'
     C                   PARM                    @PSTDT
     C                   PARM                    @PENDT
     C                   PARM                    Z2BRCA
     C                   PARM                    Z2CNUM
     C                   PARM                    Z2CCY
     C                   PARM                    Z1DLTP
     C                   PARM                    Z1DLST
 
      ** Extract the lending details using OPNQRYF and calling CG7230
     C                   CALL      'CGC7360'
     C                   PARM                    @PSTDT
     C                   PARM                    @PENDT
     C                   PARM                    Z2BRCA
     C                   PARM                    Z2CNUM
     C                   PARM                    Z2CCY
     C                   PARM                    Z1DLTP
     C                   PARM                    Z1DLST
 
      ** Extract the retail details using OPNQRYF and calling CG7260
     C                   CALL      'CGC7370'
     C                   PARM                    @PSTDT
     C                   PARM                    @PENDT
     C                   PARM                    Z2BRCA
     C                   PARM                    Z2CNUM
     C                   PARM                    Z2CCY
     C                   PARM                    Z2ACOD
     C                   PARM                    Z2ACSQ
     C                   ENDIF
