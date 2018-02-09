     H DEBUG
     H COPYRIGHT ('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL BITP - Update - Extension')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLBPLX2UP - GL BITP Update - Extension                       *
      *                                                               *
      *  Function:  This function applied the Journal entry interface *
      *             Extended Details to the Midas Database            *
      *                                                               *
      *  Component of: SP8GL0004 Service Program                      *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
     FGLJPX1PD  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLJENPDL:UPDIDX)
     F                                     COMMIT
      *****************************************************************
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
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in
      ** the PSDS. They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      *****************************************************************
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
      *
      ** Valid extended Customers Details
      *
     D GLVBITP       E DS                  EXTNAME(GLVBPLX1PD)
      *
      ** Extended IBLC Customers Details File
      *
     D NWRCD         E DS                  EXTNAME(GLJPX1PD)
      *
      ** Extended IBLC Customers Details File
      *
     D SVRCD         E DS                  EXTNAME(GLJPX1PD)
     D                                     PREFIX(SV)
      **
      **   Declared variables
      **   ==================
      **
      *
      ** "Standard" *entry parameters
      *
     D ACTN            S              1
     D WFIND           S              1
      *
      ** Modules parameters
      *
     D @RETURN         S              6
     D @TYPE           S              1
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      **
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      **
      *
      ** Access extended file
      *
     C     K@KEY1        CHAIN     UPDIDX                             8491
      *
      ** If interactive mode
      *
     C                   IF        @TYPE = '1'
      *
      ** If record locked, display screen again, with information
      ** message.
      *
     C                   IF        *IN91 = *ON
     C                   MOVEL     '*RECLCK'     @RTCD
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
      ** Insert Mode
      *
     C                   IF        WFIND <> 'Y' OR
     C                             ACTN = 'I'
      *
      ** If the record exists, the details have been modified by
      ** another user
      *
     C                   IF        *IN84 = *OFF
     C                   MOVEL     '*RECUPD'     @RTCD
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Amend/Delete Mode
      *
      ** If the record does not exist, or has been modified by another
      ** user
      *
     C                   IF        *IN84 = *ON
     C                   MOVEL     '*RECUPD'     @RTCD
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write, Reverse or Update extended file
      *
     C                   IF        ACTN <> 'R'
      *
     C                   CLEAR                   NWRCD
      *
     C                   EVAL      JEBTNB = #LLXJEBTNB
     C                   EVAL      JEBINB = #LLXJEBINB
     C                   EVAL      JEOPC1 = #LLXJEOPC1
     C                   EVAL      JECOC1 = #LLXJECOC1
     C                   EVAL      JEIDC1 = #LLXJEIDC1
     C                   EVAL      JEIDE1 = #LLXJEIDE1
     C                   EVAL      JEOPC2 = #LLXJEOPC2
     C                   EVAL      JECOC2 = #LLXJECOC2
     C                   EVAL      JEIDC2 = #LLXJEIDC2
     C                   EVAL      JEIDE2 = #LLXJEIDE2
     C                   EVAL      JEOPC3 = #LLXJEOPC3
     C                   EVAL      JECOC3 = #LLXJECOC3
     C                   EVAL      JEIDC3 = #LLXJEIDC3
     C                   EVAL      JEIDE3 = #LLXJEIDE3
     C                   EVAL      JEPTA1 = #LLXJEPTA1
     C                   EVAL      JEDCI1 = #LLXJEDCI1
     C                   EVAL      JEPTA2 = #LLXJEPTA2
     C                   EVAL      JEDCI2 = #LLXJEDCI2
     C                   EVAL      JEPTA3 = #LLXJEPTA3
     C                   EVAL      JEDCI3 = #LLXJEDCI3
      *
     C                   MOVE      NWRCD         SVRCD
      *
      ** Write or update extended record
      *
     C                   IF        *IN84 = *OFF
     C                   UPDATE    UPDIDX
     C                   ELSE
     C                   WRITE     UPDIDX
     C                   ENDIF
      *
      ** Reverse extended record
      *
     C                   ELSE
      *
     C                   DELETE    UPDIDX
      *
     C                   ENDIF
      *
     C     ENDPGM        TAG
      *
      ** Exit from program
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTN
     C                   PARM                    @RTCD
     C                   PARM                    WFIND
     C                   PARM                    GLVBITP
     C                   PARM                    SVRCD
      *
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @RETURN
     C                   PARM                    @TYPE
      *
     C     K@KEY1        KLIST
     C                   KFLD                    #LLXJEBTNB
     C                   KFLD                    #LLXJEBINB
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error
      ** processing.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005
