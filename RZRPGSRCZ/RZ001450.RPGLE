     HDebug
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Get Banks Details Today and Tomorrow')                 *
      *****************************************************************
      *                                                               *
      *  Midas - RZ Developments                                      *
      *                                                               *
      *  RZ001450 - Get Bank Details Today and Tomorrow               *
      *                                                               *
      *  Function:  This program retrieves run date and next working  *
      *             day                                               *
      *                                                               *
      *  Called By: RZC001120 - Database backups                      *
      *                                                               *
      *                                                               *
/*    *  Last Amend No. AR1084152 *Create    Date 31Jan13             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1084152 - Automate MPM dbase and archiving during CoB      *
      *            - (Child:AR1084154)                                *
      *                                                               *
      *****************************************************************
 
     FSdBankL1  IF   E           K Disk
     F                                     Rename(@BJREEF:@BankL1)
 
     D W#Today         S                   Like(BjRdNb)
     D W#Tomorrow      S                   Like(BjDNwd)
 
     C     *Entry        Plist
     C                   Parm                    W#Today
     C                   Parm                    W#Tomorrow
 
     C     KSdBankL1     Klist
     C                   KFld                    BjBank
 
     C                   Eval      BjBank = 'BANK'
     C     KSdBankL1     Chain     @BankL1
 
     C                   Eval      W#Today    = BjRdNb
     C                   Eval      W#Tomorrow = BjDNwd
 
     C                   Eval      *InLr = *On
 
