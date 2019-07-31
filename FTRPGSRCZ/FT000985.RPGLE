     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Calculate Levied Charges')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT000985  - FEES AND CHARGES: CALCULATE LEVIED CHARGE        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CFT009  *CREATE    Date 29Jun00               *
      *  Last Amend No.                    Date ddMMMyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT009 - FT Fees and Charges                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
      *****************************************************************
      *                                                               *
      *                  FUNCTION OF INDICATORS                       *
      *                                                               *
      *       80  CHAIN indicator                                     *
      *                                                               *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Currency definitions
     D P_ChgCcy        S              3
     D P_PayCcy        S                   Like(P_ChgCcy)
     D P_SettCcy       S                   Like(P_ChgCcy)
     D P_LevCcy        S                   Like(P_ChgCcy)
     D P_OtherCcy      S                   Like(P_ChgCcy)
     D FromCcy         S                   Like(P_ChgCcy)
     D ToCcy           S                   Like(P_ChgCcy)
 
      * Charge definitions
     D P_ChgAmt        S             13  0
     D LevCharge       S                   Like(P_ChgAmt)
 
      * Exchange Rate Definitions
     D P_TransR        S             13  8
     D ExchRate        S                   Like(P_TransR)
 
      * Levied charge returned in formatted form
     D LevChargeF      S             16
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
 
     C                   CallB     'FTCALCLEV'
     C                   PARM                    RetCodeIn
     C                   PARM                    P_ChgAmt
     C                   PARM                    P_PayCcy
     C                   PARM                    P_SettCcy
     C                   PARM                    P_ChgCcy
     C                   PARM                    P_LevCcy
     C                   PARM                    P_TransR
     C                   PARM                    LevCharge
     C                   PARM                    LevChargeF
 
     C                   SETON                                            LR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Entry parameters:
      *
     C     *ENTRY        PLIST
      *
      * INPUTS:
      ** Return Code (10A)
      ** Charge Amount (13,0) (In charge currency)
      ** Payment Currency (3A)
      ** Settlement Currency (3A)
      ** Charges Currency (3A)
      ** Levied Currency (3A)
      ** Exchange Rate from transaction (13,8)
     C                   PARM                    RetCodeIn
     C                   PARM                    P_ChgAmt
     C                   PARM                    P_PayCcy
     C                   PARM                    P_SettCcy
     C                   PARM                    P_ChgCcy
     C                   PARM                    P_LevCcy
     C                   PARM                    P_TransR
      *
      * OUTPUTS:
      ** Levied Charge in UNEDITED FORMAT
     C                   PARM                    LevCharge
      ** Levied Charge in EDITED FORMAT
     C                   PARM                    LevChargeF
      *
      ** Move workstation ID to screen field, initialise program name
     C                   MOVEL     'FT000985'    DBPGM
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
