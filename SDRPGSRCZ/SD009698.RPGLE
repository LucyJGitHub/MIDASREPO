     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD CSD092 Initialization pgm')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009698 - Midas SD History of Customer Information          *
      *             Initialization program                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD026854           Date 29May14               *
      *  Prev Amend No. CGL132             Date 01May13               *
      *                 MD026193           Date 07Apr14               *
      *                 CSD092   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD026854 - Alternative country of citizenship is missing in  *
      *             history of customer information                   *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  MD026193 - History of cust information is not updated        *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************
 
     FSDCUSTPD  IF   E             DISK    INFSR(*PSSR)
 
      ** =======
      ** D-specs
      ** =======
 
     D PCUST           S              6A
     D PBefCUST        S           5000A
     D PAftCUST        S           5000A
     D PBefACUS        S           5000A
     D PAftACUS        S           5000A
     D PBefFTCS        S           5000A                                                      CGL132
     D PAftFTCS        S           5000A                                                      CGL132
     D PBefJACC        S           5000A
     D PAftJACC        S           5000A
     D PBefCUAH        S           5000A
     D PAftCUAH        S           5000A
     D PBefCUXC        S           5000A                                                    MD026854
     D PAftCUXC        S           5000A                                                    MD026854
     D PACRV           S              1A
     D PELEC           S              1A                                                      CGL132
     D PCmd            S             16A   Inz('CLRPFM GPFLDDSPD')                          MD026193
     D PCmd_Len        S             15  5                                                  MD026193
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Build file fields description                                                      MD026193
     C                   EVAL      PCmd_Len = %Len(PCmd)                                    MD026193
     C                   CALL      'QCMDEXC'                                                MD026193
     C                   PARM                    PCmd                                       MD026193
     C                   PARM                    PCmd_Len                                   MD026193
                                                                                            MD026193
     C                   CALL      'GP2014001'                                              MD026193
                                                                                            MD026193
     C     1             SETLL     SDCUSTPD
     C                   READ      SDCUSTPD
 
     C                   DOW       NOT %EOF(SDCUSTPD)
 
     C                   CALL      'SD009696'
     C                   PARM      BBCUST        PCUST
     C                   PARM      *BLANKS       PBefCUST
     C                   PARM      *BLANKS       PAftCUST
     C                   PARM      *BLANKS       PBefACUS
     C                   PARM      *BLANKS       PAftACUS
     C                   PARM      *BLANKS       PBefFTCS                                     CGL132
     C                   PARM      *BLANKS       PAftFTCS                                     CGL132
     C                   PARM      *BLANKS       PBefJACC
     C                   PARM      *BLANKS       PAftJACC
     C                   PARM      *BLANKS       PBefCUAH
     C                   PARM      *BLANKS       PAftCUAH
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      *BLANKS       PACRV
     C                   PARM      *BLANKS       PELEC                                        CGL132
 
     C                   READ      SDCUSTPD
 
     C                   ENDDO
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
