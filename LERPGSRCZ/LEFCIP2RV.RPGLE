     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility LUX Retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - Lending ILE Module                                   *
      *                                                               *
      *  LEFCIP2RV - LE Facility LUX Retrieve                         *
      *                                                               *
      *  Function: This function will retrieve the details of the     *
      *            extension file.                                    *
      *                                                               *
      *  Called By: LEFCIPR - LE Facility details retrieve a record.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027A            Date 09May06               *
      *  Prev Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      *  F U N C T I O N  O F  I N D I C A T O R S                    *
      *                                                               *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *                                                               *
      *****************************************************************
     FLEFCX2PD  IF   E           K DISK
      *
      **  ER Facilities details - LUX Extension File
      *
     D                 DS
     D PReturnCode     S             10A
     D PActionCode     S              1A
     D PFntOfcId       S             20A
     D PCustNo         Ds             6
     D**KCustNo*               1      6S 0                                                   CSD027A
     D  KCustNo                1      6A                                                     CSD027A
     D PFcType         Ds             3
     D  KFcType                1      3S 0
     D PFcSeqNo        Ds             2
     D  KFcSeqNo               1      2S 0
     D PBranch         S              3A
      *
     D FCLXExFilFmt  E DS                  EXTNAME(LEFCX2PD)
      *
      ** ER Facility Details Extension File
      *
     C     Key           CHAIN     LEFCX2PD
     C                   RETURN
      *
      *****************************************************************
      *  *INZSR - Initialization Subroutine                           *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PReturnCode
     C                   PARM                    PActionCode
     C                   PARM                    PFntOfcId
     C                   PARM                    PCustNo
     C                   PARM                    PFcType
     C                   PARM                    PFcSeqNo
     C                   PARM                    PBranch
     C                   PARM                    FCLXExFilFmt
      *
     C     Key           KLIST
     C                   KFLD                    KCustNo
     C                   KFLD                    KFcType
     C                   KFLD                    KFcSeqNo
      *
     C                   CLEAR                   FCLXExFilFmt
      *
     C                   ENDSR
