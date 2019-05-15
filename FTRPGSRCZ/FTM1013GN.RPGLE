     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
 
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Rtv/calc next sequence number')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM1013GN - Retrieve the next sequence number                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 221761             Date 01Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 30May00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178751  *CREATE    Date 09May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - recompiled due to changes in PF/FT102DPD & FT102HPD *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  CFT009 - Addition of fields for FT fees and charges          *
      *           Recompile                                           *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  178751 - Auto generation of references                       *
      *                                                               *
      *****************************************************************
 
     FFT101HL3  UF   E           K DISK    Prefix(R)
     F                                     Commit
 
     FFT102HL3  UF   E           K DISK
     F                                     Commit
     FFT101DL0  IF   E           K DISK    Prefix(RD)
     FFT102DL0  IF   E           K DISK    Prefix(CD)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D TrnType         S              2
     D TrnId           S             15
     D SeqNo           S              3
     D TrnId13         S             13
     D TrnRef          S             16
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
 
     C     Key           Klist
     C                   Kfld                    TrnId
     C                   Kfld                    TrnRef
      *
      ** Retrieve sequence number from header file
      *
     C                   If        TrnType = 'RI' or TrnType = 'RO'
     C     TrnId         Chain     FT101HL3                           25
     C                   Else
     C     TrnId         Chain     FT102HL3                           25
     C                   Endif
      *
      ** Database Error
      *
     C                   If        *In25 = *On
     C                   Eval      DBFILE = 'FT101HL3'
     C                   Eval      Dbase  = 1
     C                   Eval      DBKey  =  TrnId
     C                   EXSR      *PSSR
     C                   Endif
      *
      ** Add 1 to current sequence number and pass it back to calling
      ** program
      *
     C                   If        TrnType = 'RI' or TrnType = 'RO'
     C                   Eval      *In26 = *Off
      *
      ** Check if transaction reference already exists, if so add 1
      ** to sequence number
      *
     C                   Dow       *In26 = *Off
     C                   Eval      RCSeqNo = RCSeqNo + 1
     C                   Movel     RCSeqNo       SeqNo
     C                   Movel     TrnId         TrnId13
     C     TrnId13       Cat       SeqNo         TrnRef
     C     Key           Chain     FT101DL0                           26
     C                   Enddo
 
     C                   Else
     C                   Eval      *In26 = *Off
      *
      ** Check if transaction reference already exists, if so add 1
      ** to sequence number
      *
     C                   Dow       *In26 = *Off
     C                   Eval      CSeqNo = CSeqNo + 1
     C                   Movel     CSeqNo        SeqNo
     C                   Movel     TrnId         TrnId13
     C     TrnId13       Cat       SeqNo         TrnRef
     C     Key           Chain     FT102DL0                           26
     C                   Enddo
 
     C                   Endif
      *
      ** Update header file with new sequence number
      *
     C                   If        TrnType = 'RI' or TrnType = 'RO'
     C                   Update    FT101HD0
     C                   Else
     C                   Update    FT102HD0
     C                   Endif
      *
     C                   Return
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        Begsr
 
     C     *Entry        Plist
     C                   Parm                    RetCodeIn
     C                   Parm                    TrnType
     C                   Parm                    TrnId
     C                   Parm                    SeqNo
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   Endsr                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
