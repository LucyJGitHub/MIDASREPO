     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Additional Customer/Authority Holders Updt')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUAHUPD - SD Customer/Authority Holders Details Update     *
      *                                                               *
      *  Function:  This module updates the Customer/Authority        *
      *             Holders Details                                   *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD053634           Date 21Oct19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD026854           Date 29May14               *
      *                 MD026755           Date 16May14               *
      *                 MD026780           Date 08May14               *
      *                 CGL132             Date 01May13               *
      *                 CSD092             Date 01May13               *
      *                 CER059             Date 19Jul10               *
      *                 CER034  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053634 - Requested Customer “Authority Holders Link Report *
      *             for KWG$24c” not generated.                       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD026854 - Alternative country of citizenship is missing in  *
      *             history of customer information                   *
      *  MD026755 - Unable to create customer Serious Midas Error on  *
      *             confirm authorised                                *
      *  MD026780 - Issues on Authority Holders                       *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CSD092 - Account Review                                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *  CER034 - LF046 German Features - New Fields and Enquiries    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInsert -   Insert Customer/Authority Details               *
      *  SRAmend  -   Amend Customer/Authority Details                *
      *  SRDelete -   Delete Customer/Authority Details               *
      *  *INZSR   - Program initialization routine                    *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialization only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Customer/Authority Holder Details
      *
     FSDCUAHL0  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line include (among others) the LDA layout
      ** and the copyright array definition:
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Customer to Authority Holder Link Screen File
      *
     D*CustAuth      E DS                  EXTNAME(SDCUADPD)                                  CER059
     D CustAuth      E DS                  EXTNAME(SDCUADPD1)                                 CER059
      *
      ** Midas Customer to Authority Holder Link
      *
     D SDVCUAH       E DS                  EXTNAME(SDVCUAHPD)
      *
      ** Midas Customer to Authority Holder Link
      *
     D OKCUAH        E DS                  EXTNAME(SDECUAHPD)
                                                                                              CSD092
     D SDCUAH        E DS                  EXTNAME(SDCUAHPD)                                  CSD092
     D B_CUAH        E DS                  EXTNAME(SDCUAHPD) PREFIX(B_:2)                     CSD092
     D VCUAHArr        DS                                                                   MD053634
     D V_CUAHArr                           DIM(50) LIKE(SDVCUAH)                            MD053634
                                                                                              CSD092
      ** Switchable Feature Details Data Structure                                            CSD092
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD092
                                                                                              CSD092
      ** Short Access Object Data Structure                                                   CSD092
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSD092
      *
     D UpdKey          DS
     D   DDHCUS                1      6
     D   DDHAUT                7     16
     D   DDHLTP               17     18
     D CUAHKey         DS                                                                   MD053634
     D   CBCUST                            LIKE(CACUST)                                     MD053634
     D   CBAUTH                            LIKE(CAAUTH)                                     MD053634
     D   CBLTYP                            LIKE(CALTYP)                                     MD053634
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PRtCd           S              7A
     D PRetCode        S              7A                                                    MD026755
     D KFCust          S              6A
     D KFAuth          S             10A
     D KFLtyp          S              2A
     D CSD092          S              1A   INZ('N')                                           CSD092
     D PCUST           S              6A                                                      CSD092
     D PBefCUST        S           5000A                                                      CSD092
     D PAftCUST        S           5000A                                                      CSD092
     D PBefACUS        S           5000A                                                      CSD092
     D PAftACUS        S           5000A                                                      CSD092
     D PBefFTCS        S           5000A                                                      CGL132
     D PAftFTCS        S           5000A                                                      CGL132
     D PBefJACC        S           5000A                                                      CSD092
     D PAftJACC        S           5000A                                                      CSD092
     D PBefCUAH        S           5000A                                                      CSD092
     D PAftCUAH        S           5000A                                                      CSD092
     D PBefCUXC        S           5000A                                                    MD026854
     D PAftCUXC        S           5000A                                                    MD026854
     D PACRV           S              1A                                                      CSD092
     D PELEC           S              1A                                                      CGL132
     D POptn           S              7A                                                      CSD092
     D PSARD           S              6A                                                      CSD092
     D Idx             S              3S 0                                                  MD053634
      *
      ** Timestamp for the transaction
      *
     D TimeStamp       S               Z
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the         ¦
      ** ¦ *inzsr is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Process record according to Last Change Type
      *
     C*****ACTYLC        CASEQ     'I'           SRInsert                                   MD053634
     C*****ACTYLC        CASEQ     'A'           SRAmend                                    MD053634
     C*****ACTYLC        CASEQ     'D'           SRDelete                                   MD053634
     C**********         ENDCS                                                              MD053634
                                                                                            MD053634
     C                   EXSR      SRDelete                                                 MD053634
                                                                                            MD053634
     C                   EVAL      Idx = 1                                                  MD053634
     C                   DOW       Idx <= 50                                                MD053634
     C                             AND V_CUAHArr(Idx) <> *BLANKS                            MD053634
     C                   EVAL      SDVCUAH = V_CUAHArr(Idx)                                 MD053634
     C                   EVAL      KFCust = ACCUST                                          MD053634
     C                   EVAL      KFAuth = ACAUTH                                          MD053634
     C                   EVAL      KFLtyp = ACLTYP                                          MD053634
      *                                                                                     MD053634
      ** Access Customer/Authority Details File                                             MD053634
      *                                                                                     MD053634
     C     KLCuAh        CHAIN     SDCUAHL0                                                 MD053634
     C                   IF        NOT %FOUND(SDCUAHL0)                                     MD053634
     C                   EXSR      SRInsert                                                 MD053634
     C                   ELSE                                                               MD053634
     C                   IF        ACPRG1 <> CAPRG1 or                                      MD053634
     C                             ACPRG2 <> CAPRG2 or                                      MD053634
     C                             ACPRG3 <> CAPRG3 or                                      MD053634
     C                             ACPRG4 <> CAPRG4 or                                      MD053634
     C                             ACTYPA <> CATYPA or                                      MD053634
     C                             ACCINT <> CACINT or                                      MD053634
     C                             ACPCNT <> CAPCNT                                         MD053634
     C                   EXSR      SRAmend                                                  MD053634
     C                   ENDIF                                                              MD053634
     C                   ENDIF                                                              MD053634
     C                   EVAL      Idx = Idx + 1                                            MD053634
     C                   ENDDO                                                              MD053634
      *
      ** Return from Program
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsert - Insert Customer/Authority Details                 *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls:  SRErr                                                *
      *                                                               *
      *****************************************************************
     C     SRInsert      BEGSR
      *
      ** Populate Key fields
      *
     C**********         EVAL      KFCust = ACCUST                                          MD053634
     C**********         EVAL      KFAuth = ACAUTH                                          MD053634
     C**********         EVAL      KFLtyp = ACLTYP                                          MD053634
      **********                                                                            MD053634
      ***Access*Customer/Authority*Details*File************************                     MD053634
      **********                                                                            MD053634
     C*****KLCuAh        CHAIN     SDCUAHL0                                                 MD053634
      **********                                                                            MD053634
     C**********         IF        %FOUND(SDCUAHL0)                                         MD053634
     C**********         EVAL      DBKEY  = ACCUST                                          MD053634
     C**********         EVAL      DBFILE = 'SDCUAHPD'                                      MD053634
     C**********         EVAL      DBASE  = 001                                             MD053634
     C**********         EXSR      SRErr                                                    MD053634
     C**********         ENDIF                                                              MD053634
      *
      ** Set fields on Insert
      *
     C                   EVAL      CACUST = ACCUST
     C                   EVAL      CAAUTH = ACAUTH
     C                   EVAL      CALTYP = ACLTYP
     C                   EVAL      CATYPA = ACTYPA
     C                   EVAL      CAPRG1 = ACPRG1
     C                   EVAL      CAPRG2 = ACPRG2
     C                   EVAL      CAPRG3 = ACPRG3
     C                   EVAL      CAPRG4 = ACPRG4
     C**********         EVAL      CATYLC = ACTYLC                                          MD053634
     C                   EVAL      CATYLC = 'I'                                             MD053634
     C                   EVAL      CAFRNT = ACFRNT
     C                   EVAL      CAREPA = ACREPA
     C                   IF        ACCINT = ' '                                             MD026780
     C                   EVAL      CACINT = 'N'                                             MD026780
     C                   ELSE                                                               MD026780
     C                   EVAL      CACINT = ACCINT                                            CGL132
     C                   ENDIF                                                              MD026780
     C                   EVAL      CAPCNT = ACPCNT                                            CGL132
      *
      ** Gernerate a Timestamp for the Transaction
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
     C                   MOVE      TimeStamp     CATMST
      *
      ** Write new Transaction Detail
      *
     C                   WRITE     SDCUAHD0
      *
     C                   IF        CSD092 = 'Y'                                               CSD092
                                                                                              CSD092
     C                   CALL      'SD009696'                                                 CSD092
     C                   PARM      CACUST        PCUST                                        CSD092
     C                   PARM      *BLANKS       PBefCUST                                     CSD092
     C                   PARM      *BLANKS       PAftCUST                                     CSD092
     C                   PARM      *BLANKS       PBefACUS                                     CSD092
     C                   PARM      *BLANKS       PAftACUS                                     CSD092
     C                   PARM      *BLANKS       PBefFTCS                                     CGL132
     C                   PARM      *BLANKS       PAftFTCS                                     CGL132
     C                   PARM      *BLANKS       PBefJACC                                     CSD092
     C                   PARM      *BLANKS       PAftJACC                                     CSD092
     C                   PARM      *BLANKS       PBefCUAH                                     CSD092
     C                   PARM      SDCUAH        PAftCUAH                                     CSD092
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      *BLANKS       PACRV                                        CSD092
     C                   PARM      *BLANKS       PELEC                                        CGL132
     C                   ENDIF                                                                CSD092
                                                                                              CSD092
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAmend - Amend Customer/Authority Details                   *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls:  SRErr                                                *
      *                                                               *
      *****************************************************************
     C     SRAmend       BEGSR
      *
      ***If*shadow*key*fields*contain*values,*use*it*to*Chain,*********                     MD053634
      ***else*Chain*on*file*with*the*Key*Fields*from*Valid*File********                     MD053634
      **********                                                                            MD053634
     C**********         IF        UpdKey = *BLANKS                                         MD053634
      **********                                                                            MD053634
     C**********         EVAL      KFCust = ACCUST                                          MD053634
     C**********         EVAL      KFAuth = ACAUTH                                          MD053634
     C**********         EVAL      KFLTyp = ACLTYP                                          MD053634
      **********                                                                            MD053634
     C**********         ELSE                                                               MD053634
      **********                                                                            MD053634
     C**********         EVAL      KFCust = DDHCUS                                          MD053634
     C**********         EVAL      KFAuth = DDHAUT                                          MD053634
     C**********         EVAL      KFLtyp = DDHLTP                                          MD053634
      **********                                                                            MD053634
     C**********         ENDIF                                                              MD053634
      **********                                                                            MD053634
      ***Access*Customer/Authority*Details*File***********************                      MD053634
      **********                                                                            MD053634
     C*****KLCuAh        CHAIN     SDCUAHL0                                                 MD053634
      **********                                                                            MD053634
      ***If*error*in*processing***************************************                      MD053634
      **********                                                                            MD053634
     C**********         IF        NOT %FOUND(SDCUAHL0)                                     MD053634
      **********                                                                            MD053634
     C**********         EVAL      DBKEY  = ACCUST                                          MD053634
     C**********         EVAL      DBFILE = 'SDCUAHPD'                                      MD053634
     C**********         EVAL      DBASE = 002                                              MD053634
     C**********         EXSR      SRErr                                                    MD053634
      **********                                                                            MD053634
     C**********         ENDIF                                                              MD053634
     C**********         MOVE      B_CUAH        SDCUAH                              CSD092 MD053634
     C                   EVAL      B_CUAH = SDCUAH                                          MD053634
      *
      ** Set fields on Amend
      *
     C                   EVAL      CACUST = ACCUST
     C                   EVAL      CAAUTH = ACAUTH
     C                   EVAL      CALTYP = ACLTYP
     C                   EVAL      CATYPA = ACTYPA
     C                   EVAL      CAPRG1 = ACPRG1
     C                   EVAL      CAPRG2 = ACPRG2
     C                   EVAL      CAPRG3 = ACPRG3
     C                   EVAL      CAPRG4 = ACPRG4
     C**********         EVAL      CATYLC = ACTYLC                                          MD053634
     C                   EVAL      CATYLC = 'A'                                             MD053634
     C                   EVAL      CAFRNT = ACFRNT
     C                   EVAL      CAREPA = ACREPA
     C                   IF        ACCINT = ' '                                             MD026780
     C                   EVAL      CACINT = 'N'                                             MD026780
     C                   ELSE                                                               MD026780
     C                   EVAL      CACINT = ACCINT                                            CGL132
     C                   ENDIF                                                              MD026780
     C                   EVAL      CAPCNT = ACPCNT                                            CGL132
      *
      ** Gernerate a Timestamp for the Transaction
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
     C                   MOVE      TimeStamp     CATMST
      *
      ** Update new Transaction Detail
      *
     C                   UPDATE    SDCUAHD0
      *
     C                   IF        CSD092 = 'Y'                                               CSD092
                                                                                              CSD092
     C                   CALL      'SD009696'                                                 CSD092
     C                   PARM      CACUST        PCUST                                        CSD092
     C                   PARM      *BLANKS       PBefCUST                                     CSD092
     C                   PARM      *BLANKS       PAftCUST                                     CSD092
     C                   PARM      *BLANKS       PBefACUS                                     CSD092
     C                   PARM      *BLANKS       PAftACUS                                     CSD092
     C                   PARM      *BLANKS       PBefFTCS                                     CGL132
     C                   PARM      *BLANKS       PAftFTCS                                     CGL132
     C                   PARM      *BLANKS       PBefJACC                                     CSD092
     C                   PARM      *BLANKS       PAftJACC                                     CSD092
     C                   PARM      B_CUAH        PBefCUAH                                     CSD092
     C                   PARM      SDCUAH        PAftCUAH                                     CSD092
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      *BLANKS       PACRV                                        CSD092
     C                   PARM      *BLANKS       PELEC                                        CGL132
     C                   ENDIF                                                                CSD092
                                                                                              CSD092
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDelete - Delete Customer/Authority Details                 *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls:  SRErr                                                *
      *                                                               *
      *****************************************************************
     C     SRDelete      BEGSR
      *
      ** Populate Key fields
      *
     C**********         EVAL      KFCust = ACCUST                                          MD053634
     C**********         EVAL      KFAuth = ACAUTH                                          MD053634
     C**********         EVAL      KFLtyp = ACLTYP                                          MD053634
      **********                                                                     CER059 MD053634
      ***Delete*all*records*for*a*given*customer**********************               CER059 MD053634
      **********                                                                     CER059 MD053634
     C**********         IF        KFAuth = *BLANKS                                  CER059 MD053634
     C**********                   AND KFLtyp = *BLANKS                              CER059 MD053634
     C*****KLcuAh        SETLL     SDCUAHL0                                          CER059 MD053634
     C**********         READ      SDCUAHL0                                          CER059 MD053634
     C**********         DOW       NOT %EOF(SDCUAHL0)                                CER059 MD053634
     C**********                   AND KFCust =  CACUST                              CER059 MD053634
     C**********         DELETE    SDCUAHD0                                          CER059 MD053634
     C**********         READ      SDCUAHL0                                          CER059 MD053634
     C**********         ENDDO                                                       CER059 MD053634
      **********                                                                     CER059 MD053634
     C**********         ELSE                                                        CER059 MD053634
      **********                                                                            MD053634
      ***Access*Customer/Authority Details File***********************                      MD053634
      **********                                                                            MD053634
     C*****KLCuAh        CHAIN     SDCUAHL0                                                 MD053634
      **********                                                                            MD053634
     C**********         IF        NOT %FOUND(SDCUAHL0)                                     MD053634
     C**********         EVAL      DBKEY  = ACCUST                                          MD053634
     C**********         EVAL      DBFILE = 'SDCUAHPD'                                      MD053634
     C**********         EVAL      DBASE  = 003                                             MD053634
     C**********         EXSR      SRErr                                                    MD053634
     C**********         ENDIF                                                              MD053634
      **********                                                                            MD053634
      ***Delete*Transaction Detail************************************                      MD053634
      **********                                                                            MD053634
     C**********         DELETE    SDCUAHD0                                                 MD053634
                                                                                            MD053634
     C                   EVAL      KFCust = V_CUAHArr(1)                                    MD053634
     C                   EVAL      KFAuth = *blanks                                         MD053634
     C                   EVAL      KFLtyp = *blanks                                         MD053634
     C     KLcuAh        SETLL     SDCUAHL0                                                 MD053634
     C                   READ      SDCUAHL0                                                 MD053634
     C                   DOW       NOT %EOF(SDCUAHL0)                                       MD053634
     C                             AND KFCust =  CACUST                                     MD053634
     C                   EVAL      CBCUST = CACUST                                          MD053634
     C                   EVAL      CBAUTH = CAAUTH                                          MD053634
     C                   EVAL      CBLTYP = CALTYP                                          MD053634
      ** When record not found                                                              MD053634
     C                   IF        %SCAN(CUAHKey:VCUAHArr) = 0                              MD053634
     C                   EVAL      B_CUAH = SDCUAH                                          MD053634
     C                   EVAL      CATYLC = 'D'                                             MD053634
      *                                                                                     MD053634
      ** Gernerate a Timestamp for the Transaction                                          MD053634
      *                                                                                     MD053634
     C                   CALLB     'ZAGENTMSTM'                                             MD053634
     C                   PARM                    TimeStamp                                  MD053634
      *                                                                                     MD053634
     C                   MOVE      TimeStamp     CATMST                                     MD053634
     C                   UPDATE    SDCUAHD0                                                 MD053634
      *
     C                   IF        CSD092 = 'Y'                                               CSD092
                                                                                              CSD092
     C                   CALL      'SD009696'                                                 CSD092
     C                   PARM      CACUST        PCUST                                        CSD092
     C                   PARM      *BLANKS       PBefCUST                                     CSD092
     C                   PARM      *BLANKS       PAftCUST                                     CSD092
     C                   PARM      *BLANKS       PBefACUS                                     CSD092
     C                   PARM      *BLANKS       PAftACUS                                     CSD092
     C                   PARM      *BLANKS       PBefFTCS                                     CGL132
     C                   PARM      *BLANKS       PAftFTCS                                     CGL132
     C                   PARM      *BLANKS       PBefJACC                                     CSD092
     C                   PARM      *BLANKS       PAftJACC                                     CSD092
     C**********         PARM      SDCUAH        PBefCUAH                            CSD092 MD053634
     C                   PARM      B_CUAH        PBefCUAH                                   MD053634
     C                   PARM      *BLANKS       PAftCUAH                                     CSD092 
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      *BLANKS       PACRV                                        CSD092
     C                   PARM      *BLANKS       PELEC                                        CGL132
     C                   ENDIF                                                                CSD092
                                                                                              CSD092
     C                   ENDIF                                                                CER059
     C                   READ      SDCUAHL0                                                 MD053634
     C                   ENDDO                                                              MD053634
                                                                                              CER059
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C**********         PARM                    PRtCd                                      MD026755
     C                   PARM                    PRetCode                                   MD026755
     C**********         PARM                    UpdKey                                     MD053634
     C**********         PARM                    SDVCUAH                                    MD053634
     C                   PARM                    VCUAHArr                                   MD053634
                                                                                              CSD092
      ** Check if CSD092 is enabled.                                                          CSD092
                                                                                              CSD092
     C                   EVAL      CSD092 = 'N'                                               CSD092
     C                   CALL      'AOSARDR0'                                                 CSD092
     C                   PARM      *BLANKS       PRtCd                                        CSD092
     C                   PARM      '*VERIFY'     POptn                                        CSD092
     C                   PARM      'CSD092'      PSARD                                        CSD092
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD092
                                                                                              CSD092
     C                   IF        PRtCd = *BLANKS                                            CSD092
     C                   EVAL      CSD092 = 'Y'                                               CSD092
     C                   ELSE                                                                 CSD092
                                                                                              CSD092
     C                   IF        PRtCd <> '*NRF   '                                         CSD092
     C     *LOCK         IN        LDA                                                        CSD092
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD092
     C                   EVAL      DBKey = PSARD                                              CSD092
     C                   EVAL      DBase = 107                                                CSD092
     C                   OUT       LDA                                                        CSD092
     C                   EXSR      *PSSR                                                      CSD092
     C                   ENDIF                                                                CSD092
                                                                                              CSD092
     C                   ENDIF                                                                CSD092
      *
      ** Key List to access Customer/Authority Holder File
      *
     C     KLCuAh        KLIST
     C                   KFLD                    KFCust
     C                   KFLD                    KFAuth
     C                   KFLD                    KFLTyp
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - Exception Errors                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C**********         EVAL      PRtCd = '*ERROR '
     C                   EVAL      PRetCode = '*ERROR '                                     MD026755
     C                   EVAL      DBPGM = 'SDCUAHUPD'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
      *
      **  Terminate the program
      *
     C                   RETURN
      *
     C                   ENDSR
      ****************************************************************
      *
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,PSSR_ILE
