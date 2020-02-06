     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('AO Interest Payment History')                          *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  AOINPHU0 - AO Interest Payment History                       *
      *                                                               *
      *  Function: This program updates the interest payment history  *
      *            file for the joint customer with the threshold     *
      *            limit utilisation and total net interest when      *
      *            interest is posted by the DL and RE modules        *
      *                                                               *
      *     ANY CHANGES DONE TO THIS PROGRAM MUST BE REFLECTED        *                    BUG24630A
      *        ON AOINPHU1                                            *                    BUG24630A
      *                                                               *                    BUG24630A
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG26873           Date 13Jan09               *
      *                 BUG24630A          Date 02Jul09               *
      *                 BUG24051           Date 26May09               *
      *                 BUG23732*CREATE    Date 23Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26873 - Threshold limit utilization not posted to the     *
      *             member account (partly posted to the main joint   *
      *             acct and the other part unposted) based on limit  *
      *             utilization enquiry                               *
      *  BUG24630A - In MM and Retail Interest Calculation Threshold  *
      *              is not being Deducted. Amended the header.       *
      *  BUG24051 - Incorrect Threshold Utilisation Postings          *
      *  BUG23732 - Joint Account threshold                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas SD Interest Payment History File
     FSDINPHL1  UF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD Interest Payment History File
     FSDINPHL3  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDINPHD0:SDINPHD3)
      *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR     - Program Initialisation Routine                  *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *  SRMain     - Main processing                                 *
      *  SRUpdate   - Update the file SDINPHPD                        *
      *  SRSprdUtil - Spread utilisation                              *
      *  SRUpdUtil  - Update Threshold Limit Utilisation              *
      *  *PSSR      - Program Error Processing Subroutine             *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
      *
      /COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
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
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Program Variables used
      *
     D PRtncd          S              7A
     D PCust           S              6A
     D PThLmUtil       S             15P 0
     D PGrosIntB       S             15P 0
     D PTaxB           S             15P 0
     D PNetIntB        S             15P 0
      *
      ** Work variables used in the program
      *
     D WNewUtil        S             15P 0
     D WJointTh        S             15P 0
     D WCust           S              6A
     D WCuth           S             15P 0                                                  BUG24051
     D BaseNBDP        S              1S 0                                                  BUG24051
      *
     D KCust           S              6A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically:the *INZSR is¦
      ** ¦ executed at program activation.                            ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Main processing
      *
     C                   EXSR      SRMain
      *
      ** End the program
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMain - Processing subroutine                                *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: SRUpdUtil                                              *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR
      *
     C     PCust         CHAIN     SDINPHL1
      *
     C                   IF        %FOUND(SDINPHL1)
     C                   EXSR      SRUpdate
      *
     C                   ELSE
     C                   EVAL      PRtncd = 'Y'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate  - Update the file SDINPHPD                          *
      *                                                               *
      * Called by: SRmain                                             *
      *                                                               *
      * Calls:    SRUpdUtil                                           *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
      *                                                                                     BUG24051
     C                   EVAL      WCuth = TICUTH                                           BUG24051
     C                   IF        BaseNBDP > 0                                             BUG24051
     C                   EVAL      WCuth = WCuth * (10 ** BaseNBDP)                         BUG24051
     C                   ENDIF                                                              BUG24051
      *
      ** If Customer not part of a joint account
      ** then set utilisation to parameter
      *
     C                   IF        TIJOIN = *BLANKS
     C                             OR PJAMG <> '3'                                          BUG26873
     C                   IF        PThLmUtil <= WCuth                                       BUG24051
     C                   EVAL      TIUTTH = PThLmUtil
     C                   EVAL      TIGSIN = TIGSIN + PGrosIntB
     C                   EVAL      TITTAX = TITTAX + PTaxB
     C                   EVAL      TITOUT = TITOUT + PNetIntB
     C                   UPDATE    SDINPHD0
     C                   ELSE                                                               BUG24051
     C                   EVAL      TIUTTH = WCuth                                           BUG24051
     C                   EVAL      TIGSIN = TIGSIN + PGrosIntB                              BUG24051
     C                   EVAL      TITTAX = TITTAX + PTaxB                                  BUG24051
     C                   EVAL      TITOUT = TITOUT + PNetIntB                               BUG24051
     C                   UPDATE    SDINPHD0                                                 BUG24051
     C                   ENDIF                                                              BUG24051
      *
      ** If Customer is part of a joint account
      *
     C                   ELSE
      *
      ** If new utilisation is less than limit set for individual
      ** customer
      *
     C**********         IF        PThLmUtil < TICUTH                                       BUG24051
     C                   IF        PThLmUtil <= WCuth                                       BUG24051
     C                   EVAL      TIUTTH = PThLmUtil
     C                   EVAL      TIGSIN = TIGSIN + PGrosIntB
     C                   EVAL      TITTAX = TITTAX + PTaxB
     C                   EVAL      TITOUT = TITOUT + PNetIntB
     C                   UPDATE    SDINPHD0
      *
      ** If new utilisation is more than the limit set for individual
      ** customer
      *
     C                   ELSE
     C**********         EVAL      TIUTTH = TICUTH                                          BUG24051
     C                   EVAL      TIUTTH = WCuth                                           BUG24051
     C                   EVAL      TIGSIN = TIGSIN + PGrosIntB
     C                   EVAL      TITTAX = TITTAX + PTaxB
     C                   EVAL      TITOUT = TITOUT + PNetIntB
     C                   UPDATE    SDINPHD0
      *
      ** Spread utilisation with joint customer first and then
      ** spread utilisation with rest of members
      *
     C                   EXSR      SRSprdUtil
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSprdUtil - Spread utilisation                               *
      *                                                               *
      * Called by: SRUpdate                                           *
      *                                                               *
      * Calls:    SRUpdUtil                                           *
      *                                                               *
      *****************************************************************
     C     SRSprdUtil    BEGSR
      *
     C                   EVAL      WJointTh  = PThLmUtil
     C**********         EVAL      WJointTh  = WJointTh - TICUTH                            BUG24051
     C                   EVAL      WJointTh  = WJointTh - WCuth                             BUG24051
     C                   EVAL      KCust = TIJOIN
      *
     C     KCust         SETLL     SDINPHL3
     C     KCust         READE     SDINPHL3
      *
     C                   DOW       NOT %EOF(SDINPHL3) AND
     C                             WJointTh > *ZEROS
      *
     C                   IF        PCust <> TICUST
     C                   EXSR      SRUpdUtil
     C                   ENDIF
      *
     C     KCust         READE     SDINPHL3
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdUtil - Update Threshold Limit Utilisation                *
      *                                                               *
      * Called by: SRmain                                             *
      *                                                               *
      * Calls:    None                                                *
      *                                                               *
      *****************************************************************
     C     SRUpdUtil     BEGSR
      *
     C                   EVAL      WCuth = TICUTH                                           BUG24051
     C                   IF        BaseNBDP > 0                                             BUG24051
     C                   EVAL      WCuth = WCuth * (10 ** BaseNBDP)                         BUG24051
     C                   ENDIF                                                              BUG24051
      *                                                                                     BUG24051
     C                   EVAL      WNewUtil = TIUTTH + WJointTh
      *
     C**********         IF        WNewUtil <= TICUTH                                       BUG24051
     C                   IF        WNewUtil <= WCuth                                        BUG24051
     C                   EVAL      TIUTTH = WNewUtil
     C                   EVAL      WJointTh = *ZEROS
      *
     C                   ELSE
     C**********         EVAL      TIUTTH = TICUTH
     C**********         EVAL      WJointTh = WNewUtil - TICUTH
     C                   EVAL      TIUTTH = WCuth                                           BUG24051
     C                   EVAL      WJointTh = WNewUtil - WCuth                              BUG24051
     C                   ENDIF
      *
     C                   UPDATE    SDINPHD3
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Processing                                   *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRtncd
     C                   PARM                    PCust
     C                   PARM                    PThLmUtil
     C                   PARM                    PGrosIntB
     C                   PARM                    PTaxB
     C                   PARM                    PNetIntB
     C                   PARM                    BaseNBDP                                   BUG24051
     C                   PARM                    PJAMG             1                        BUG26873
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error
      ** processing.
      *****************************************************************
      *
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
** CTDATA CPY@
(c) Finastra International Limited 2009
