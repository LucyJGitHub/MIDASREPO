     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CUSD - Update - LU Window')
      *****************************************************************
      *                                                               *
      *  Midas - IBLC 2002 Module                                     *
      *                                                               *
      *  SDCUSD3UP - SD Customers Extension Update - LU Window        *
      *                                                               *
      *  Function:  This function applied the Customers Extended      *
      *             Details to the Midas Database                     *
      *                                                               *
      *  Component of:  SP8SD0006 - Core Luxembourg service program   *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG13597           Date 20Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG13597 - MidasPlus Error encountered when authorising an   *
      *             amend transaction                                 *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
 
     FSDCUX1PD  UF A E           K DISK
     F                                     RENAME(SDCUSTDL:UPDIDX)
     F                                     COMMIT
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
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
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
      *
      ** Valid extended Customers Details
      *
     D SDVCUSD       E DS                  EXTNAME(SDVCULX1PD)
      *
      ** Extended IBLC Customers Details File
      *
     D NWRCD         E DS                  EXTNAME(SDCUX1PD)
      *
      ** Extended IBLC Customers Details File
      *
     D SVRCD         E DS                  EXTNAME(SDCUX1PD)
     D                                     PREFIX(SV)
 
      **
      **   Declared variables
      **   ==================
      **
      *
      ** "Standard" *entry parameters
      *
     D PACTN           S              1
     D PFIND           S              1
      *
      ** Modules parameters
      *
     D PRtCd           S              7
     D PReturn         S              6
     D PType           S              1
 
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
      ** Access extended file
      *
     C                   MOVE      #LLXCUCNUM    K@CNUM
     C     K@KEY1        CHAIN     UPDIDX                             8491
      *
      ** If interactive mode
      *
     C                   IF        PType = '1'
      *
      ** If record locked, display screen again, with information
      ** message.
      *
     C                   IF        *IN91 = *ON
     C                   MOVEL     '*RECLCK'     PRtCd
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
      ** Insert Mode
      *
     C                   IF        PFIND <> 'Y'
      *
      ** If the record exists, the details have been modified by
      ** another user
      *
     C                   IF        *IN84 = *OFF
     C                   MOVEL     '*RECUPD'     PRtCd
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Amend/Delete Mode
      ** If the record does not exist, or has been modified by another
      ** user
      *
     C**********         IF        *IN84 = *ON OR                                           BUG13597
     C**********                   *IN84 = *OFF AND                                         BUG13597
     C**********                   NWRCD <>  SVRCD                                          BUG13597
     C                   IF        *IN84 = *ON                                              BUG13597
     C                   MOVEL     '*RECUPD'     PRtCd
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write, delete or Update extended file
      *
     C                   IF        PACTN= 'D'
      *
     C                   ELSE
      *
     C                   EVAL      CUCNUM  =  #LLXCUCNUM
     C                   EVAL      CUTYPE  =  #LLXCUTYPE
     C                   EVAL      CUIDCO  =  #LLXCUIDCO
     C                   EVAL      CUIDEN  =  #LLXCUIDEN
     C                   EVAL      CUIMCO  =  #LLXCUIMCO
     C                   EVAL      CUIMNB  =  #LLXCUIMNB
      *
      ** Write or update extended record
      *
     C                   IF        *IN84 = *OFF
     C                   UPDATE    UPDIDX
     C                   ELSE
     C                   WRITE     UPDIDX
     C                   ENDIF
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
     C                   PARM                    PACTN
     C                   PARM                    PRtCd
     C                   PARM                    PFIND
     C                   PARM                    SDVCUSD
     C                   PARM                    SVRCD
      *
      ** Determine whether program is running interactively or in batch
      ** ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    PReturn
     C                   PARM                    PType
      *
      ** Define key to access to extended details
      *
     C     *LIKE         DEFINE    CUCNUM        K@CNUM
      *
     C     K@KEY1        KLIST
     C                   KFLD                    K@CNUM
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005
