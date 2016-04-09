     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('SD Currency/Time of Netting Details')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCTNMRED - SD Currency/Time of Netting Details Read         *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the SD Currency/Time of Netting           *
      *             Details file                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. AR1086546 *CREATE  Date 19Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1086546 - Upgrade of CDL025 to MP1.4 (Child: AR1086547).   *
      *              Applied for MD021813                             *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Currency/Time of Netting Details file
     FSDCTNML1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCTNMP0:TrnFmat)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry parameters
     D DDACTN          S              1A
     D DDCUST          S              6A
     D PRDFWD          S              1A
     D PRDBCK          S              1A
     D PERRMS          S              7A
     D PCNRED          S              6A
 
     D ZACTN           S              1A
     D PERR            S              1P 0
 
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
 
      ** Initialise outputs
 
     C                   EVAL      PERRMS = *BLANK
     C                   EVAL      PCNRED = *BLANK
 
      ** Check for user authority to browse if not multi-branching
 
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
 
      ** Read forwards
 
     C                   IF        PRDFWD = 'Y'
     C                   EXSR      RDFWD
     C                   ELSE
 
      ** Read backwards
 
     C                   IF        PRDBCK = 'Y'
     C                   EXSR      RDBCK
     C                   ENDIF
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial processing                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
 
      ** Input parameters :
      ** Return code
 
     C                   PARM                    RetCodeIn
 
      ** Action code
 
     C                   PARM                    DDACTN
 
      ** Customer Number reference
 
     C                   PARM                    DDCUST
 
      ** Read forwards
 
     C                   PARM                    PRDFWD
 
      ** Read backwards
 
     C                   PARM                    PRDBCK
 
      ** Output Parameters :
      ** Error meassage
 
     C                   PARM                    PERRMS
 
      ** Customer Number read
 
     C                   PARM                    PCNRED
 
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'SDCTNMRED'
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE =  900
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  RDFWD - Read forwards through Currency/Time of Netting       *
      *          Details file                                         *
      *                                                               *
      *****************************************************************
     C     RDFWD         BEGSR
 
      ** Position to current record on file
 
     C     DDCUST        SETGT     TRNFMAT
 
      ** Read until end of file or a valid record is found or an error
 
     C                   DOU       *IN99 = *ON OR
     C                             LCUST <> *BLANKS AND
     C                             PERR = *ZERO AND
     C                             LTYLC <> 'D'
 
      ** Read next transaction
 
     C                   READ      TRNFMAT                                99
      *
     C                   ENDDO
 
      ** If end of file was encountered, report this fact
 
     C                   IF        *IN99 = *ON
     C                   EVAL      PERRMS = 'MMM1002'
 
      ** Else, return the Customer Number read
 
     C                   ELSE
     C                   MOVE      LCUST         PCNRED
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RDBCK - Read backwards through Currency/Time of Netting       *
      *         details file                                          *
      *                                                               *
      *****************************************************************
     C     RDBCK         BEGSR
 
      ** Position to current record on file
 
     C     DDCUST        SETLL     TRNFMAT
 
      ** Read until end of file or a valid record is found or an error
 
     C                   DOU       *IN99 = *ON OR
     C                             LCUST <> *BLANKS AND
     C                             PERR = *ZERO AND
     C                             LTYLC <> 'D'
 
      ** Read next transaction
 
     C                   READP     TRNFMAT                                99
      *
     C                   ENDDO
 
      ** If start of file was encountered, report this fact
 
     C                   IF        *IN99 = *ON
     C                   EVAL      PERRMS = 'MMM1003'
 
      ** Else, return the Customer Number read
 
     C                   ELSE
     C                   MOVE      LCUST         PCNRED
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CHAUTN - Check for user authority if not multi-branching      *
      *                                                               *
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    PERR
 
      ** Return error message
 
     C                   IF        PERR  = 1
     C                   EVAL      PERRMS = 'FXM0292'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
