     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE CLIP Update - Extension')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LECLIP2UP - SD Customers Extension Update - LU Window        *
      *                                                               *
      *  Function:  This function applied the Customers Loan          *
      *             Extension Detail.                                 *
      *                                                               *
      *  Called by: LECLIPVU - LE Loan Details Validate and Update    *
      *                                                               *
      *  (c) Midas International Banking System Ltd. 2005             *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  81 - Record found indicator                                  *
      *  91 - Database record lock                                    *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRSETFLD - Set Fields Routine                                *
      *                                                               *
      *****************************************************************
 
     FLECLX1PD  UF A E           K DISK
     F                                     RENAME(CLOANKF6:UPDIDX)
     F                                     COMMIT
      *
      ** ER Customer Loans - LUX Extension File
      *
 
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                         error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      **
 
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Standard D specifications
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** MM standard variable declares
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** PSDS Layout
      *
 
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
 
     D VaLidCLIPEx   E Ds                  EXTNAME(LEVCLLX1PD)
      *
      ** ER Customer Loan Extension Valid File
      *
     D NWRCD         E DS                  EXTNAME(LECLX1PD)
      *
      ** ER Customer Loan Extension Valid File
      *
     D CLIPFilFmt    E DS                  EXTNAME(LECLX1PD)
     D                                     PREFIX(SV)
      *
      ** ER Customer Loan Extension Valid File
      *
 
      **
      **   Declared variables
      **   ==================
      **
 
     D                 Ds
      *
      ** "Standard" *entry parameters
      *
     D PFIND           S              1A
 
     D                 Ds
      *
      ** Modules parameters
      *
     D P@RETURN        S              6A
     D PTYPE           S              1A
     D PActionCode     S              1A
     D PRTCD           S              7A
 
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      *
      *
      ***  Access extended file
      *
     C     LKLNRF        CHAIN     LECLX1PD                           8491
      *
      ** If interactive mode.
      *
     C                   IF        PTYPE   = '1'
      *
      ** If record is locked, display screen again, with information
      ** message.
      *
     C                   IF        *IN91
     C                   EVAL      PRTCD   = '*RECLCK'
     C                   RETURN
     C                   ENDIF
      *
      ** Insert Mode
      *
     C                   IF        PActionCode = 'I'
      *
      ** If the record exists, the details have been modified by
      ** another user.
      *
     C                   IF        NOT *IN84
     C                   EVAL      PRTCD   = '*RECUPD'
     C                   RETURN
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Amend/Delete Mode
      *
      *
      ** If the record does not exist, or has been modified by
      ** another user.
      *
     C                   IF        *IN84
     C                   EVAL      PRTCD   = '*RECUPD'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write, delete or Update extended file
      *
     C                   IF        PActionCode = 'D'
      *
      ** Delete record
      *
     C                   IF        NOT *IN84
     C                   DELETE    UPDIDX
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   EXSR      SRSETFLD
      *
      ** Write or update extended record
      *
     C                   IF        NOT *IN84
     C                   UPDATE    UPDIDX
     C                   ELSE
     C                   WRITE     UPDIDX
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Exit from program
      *
     C                   RETURN
      *
      /EJECT
 
      *****************************************************************
      *  SRSETFLD - Set Field Routine                                 *
      *  Called by: Main Routine                                      *
      *  Calls: None                                                  *
      *****************************************************************
     C     SRSETFLD      BEGSR
     C                   EVAL      VKLNRF  = LKLNRF
     C                   EVAL      VKSUBR  = LKSUBR
     C                   EVAL      VKMOBL  = LKMOBL
     C                   EVAL      VKRISC  = LKRISC
     C                   EVAL      VKIMEX  = LKIMEX
     C                   EVAL      VKPPSC  = LKPPSC
     C                   EVAL      VKCOAM  = LKCOAM
     C                   EVAL      VKDGRI  = LKDGRI
     C                   EVAL      VKIM93  = LKIM93
     C                   EVAL      VKCLAT  = LKCLAT
     C                   EVAL      VK1UAC  = LK1UAC
     C                   EVAL      VKLUSU  = LKLUSU
     C                   EVAL      VKLURA  = LKLURA
     C                   ENDSR
      /EJECT
 
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    PActionCode
     C                   PARM                    PRTCD
     C                   PARM                    PFIND
     C                   PARM                    ValidCLIPEx
     C                   PARM                    CLIPFilFmt
      *
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    P@RETURN
     C                   PARM                    PTYPE
     C                   ENDSR
      *****************************************************************
