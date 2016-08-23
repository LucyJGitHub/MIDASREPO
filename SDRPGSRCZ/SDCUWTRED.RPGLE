     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Withholding Tax Details Read')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUWTRED - SD Customer Withholding Tax Details              *
      *                                                               *
      *  Function:  This module reads forwards and backwards through  *
      *             the SD Customer Withholding Tax details file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Customer Withholding Tax details file - by customer
      ** Number & Country of Tax Treaty
     FSDWTCSL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDWTCSD0:@WTCSL1)
 
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
     D DDCSNO          S              6A
     D PRDFWD          S              1A
     D PRDBCK          S              1A
     D PERRMS          S              7A
     D PCSRED          S              6A
 
     D PRTCD           S              7A
     D POPTN           S              7A
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
     C                   EVAL      PCSRED = *BLANK
 
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
      *  *INZSR - Initial processing                                  *
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
 
     C                   PARM                    DDCSNO
 
      ** Read forwards
 
     C                   PARM                    PRDFWD
 
      ** Read backwards
 
     C                   PARM                    PRDBCK
 
      ** Output Parameters :
      ** Error meassage
 
     C                   PARM                    PERRMS
 
      ** Customer Number read
 
     C                   PARM                    PCSRED
 
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'SDCUWTRED'
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  RDFWD - Read forwards through Customer Withholding Tax       *
      *         details file                                          *
      *****************************************************************
     C     RDFWD         BEGSR
 
      ** Position to current record on file
 
     C     DDCSNO        SETGT     @WTCSL1
 
      ** Read until end of file or a valid record is found or an error
 
     C                   DOU       *IN99 = *ON OR
     C                             WHCSNO <> *BLANKS AND
     C                             PERR = *ZERO AND
     C                             WHTYLC <> 'D'
 
      ** Read next transaction
 
     C                   READ      @WTCSL1                                99
 
     C                   ENDDO
 
      ** If end of file was encountered, report this fact
 
     C                   IF        *IN99 = *ON
     C                   EVAL      PERRMS = 'MMM1002'
 
      ** Else, return the Customer Number read
 
     C                   ELSE
     C                   MOVE      WHCSNO        PCSRED
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RDBCK - Read backwards through Customer Withholding Tax      *
      *         details file                                          *
      *                                                               *
      *****************************************************************
     C     RDBCK         BEGSR
 
      ** Position to current record on file
 
     C     DDCSNO        SETLL     @WTCSL1
 
      ** Read until end of file or a valid record is found or an error
 
     C                   DOU       *IN99 = *ON OR
     C                             WHCSNO <> *BLANKS AND
     C                             PERR = *ZERO AND
     C                             WHTYLC <> 'D'
 
      ** Read next transaction
 
     C                   READP     @WTCSL1                                99
 
     C                   ENDDO
 
      ** If start of file was encountered, report this fact
 
     C                   IF        *IN99 = *ON
     C                   EVAL      PERRMS = 'MMM1003'
 
      ** Else, return the Customer Number read
 
     C                   ELSE
     C                   EVAL      PCSRED = WHCSNO
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CHAUTN - Check for user authority if not multi-branching      *
      *                                                               *
      *****************************************************************
     C     CHAUTN        BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    PERR
 
      ** Return error message
 
     C                   IF        PERR = 1
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
Misys International Banking Systems Ltd. 2007
