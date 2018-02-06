     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AP Reorganization of Valid API files')           *
      *****************************************************************
      *                                                               *
      *  Midas - APIs module                                          *
      *                                                               *
      *  APREORGVAL - Reorganize Valid Files                          *
      *                                                               *
      *  Function:  This module reorganize valid files every each     *
      *             COB followed by non-working day.                  *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR739558           Date 22Nov12               *
      *                 AR574025 *CREATE   Date 22Nov12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR739558 - Additional fix for AR574025 to include the 3      *
      *             extension valid files to be also reorganized by   *
      *             this component during COB: GLVAMBXPD, GLVAMCOPD   *
      *             and GLVAMRIPD (Child: AR739559)                   *
      *  AR574025 - Reorganize valid files every each COB followed by *
      *             non-working day and if 'Clear Invalid Items' field*
      *             in API-ICD maintenance is 'N'. (Child: AR574026)  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ! F-specs                              !
      ** ! =======                              !
      ** +--------------------------------------+
 
     FAPDBINFPD IF   E             DISK    USROPN
 
      *****************************************************************
      ** +--------------------------------------+
      ** ! Automatically included D-specs       !
      ** ! ==============================       !
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ! End of automatically included D-specs!
      ** ! =====================================!
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ! Manually included D-specs            !
      ** ! =========================            !
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ! Named constants                      !
      ** ! ===============                      !
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ! Arrays and Data Structures           !
      ** ! ==========================           !
      ** +--------------------------------------+
      *
     D Indicators      DS                  BASED(pIndicator)
      *
     D  EndOfFile             99     99
      *
     D pIndicator      S               *   INZ(%Addr(*In))
      ** Set the indicator array pointer
      *
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access programs
      *
 
      ** +--------------------------------------+
      ** ! Declared variables                   !
      ** ! ==================                   !
      ** +--------------------------------------+
 
      *
      ** File to clear
      *
     D File            S             10A
     D Member          S             10A
      *
      ** Job switches string for passing to UTSETJOBSW
      *
     D Switches        S              8A   INZ('XXXXXXXX')
 
      ** +--------------------------------------+
      ** ! End of D-specs                       !
      ** ! ==============                       !
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** !                                                            !
      ** ! Initial processing is performed automatically: the *inzsr  !
      ** ! is executed at program activation.                         !
      ** !                                                            !
      ** +------------------------------------------------------------+
 
     C                   IF        GHCLIN = 'N'
      *
      ** Reorganise Valid API files.
      ** Note: Any valid file added to the APDBINFPD file should
      **       also be added here.
      *
     C                   OPEN      APDBINFPD
      *
     C                   DOU       EndOfFile = True
      *
     C                   READ      APDBINFPD                              99
      *
     C                   IF        EndOfFile = True
     C                   LEAVE
     C                   ENDIF
      *
     C                   EVAL      File = AQUPDFIL
     C                   EXSR      ReorgFile
      *
     C                   ENDDO
      *
      ** Funding participants (FPRT) Valid file - record A.
      *
     C                   EVAL      File = 'LEVFCLMPD'
     C                   EXSR      ReorgFile
      *
      ** Funding participants (FPRT) Valid file - record B.
      *
     C                   EVAL      File = 'LEVFCLNPD'
     C                   EXSR      ReorgFile
      *
      ** Midas FT Valid Incoming Payments Extension File
      *
     C                   EVAL      File = 'FTVIPY2PD'
     C                   EXSR      ReorgFile
      *
      ** Midas FT Valid Outgoing Payments Extension File
      *
     C                   EVAL      File = 'FTVOPY2PD'
     C                   EXSR      ReorgFile
      *
      ** Valid Customer Additional details File layout
      *
     C                   EVAL      File = 'SDVCUADPD'
     C                   EXSR      ReorgFile
      *
      ** Valid Customer marketing File layout
      *
     C                   EVAL      File = 'SDVCUMIPD'
     C                   EXSR      ReorgFile
      *
      ** Midas SD API Customer fmt defn file-valid SWIFT
      *
     C                   EVAL      File = 'SDVSWSDPD'
     C                   EXSR      ReorgFile
      *
      ** CUSD API valid   additional data
      *
     C                   EVAL      File = 'SDVCUW9PD'
     C                   EXSR      ReorgFile
      *                                                                                     AR739558
      ** Midas GL API account maint details extension file valid                            AR739558
      *                                                                                     AR739558
     C                   EVAL      File = 'GLVAMBXPD'                                       AR739558
     C                   EXSR      ReorgFile                                                AR739558
      *                                                                                     AR739558
      ** Midas GL API Account Maint. RE Comm. extension file valid                          AR739558
      *                                                                                     AR739558
     C                   EVAL      File = 'GLVAMCOPD'                                       AR739558
     C                   EXSR      ReorgFile                                                AR739558
      *                                                                                     AR739558
      ** Midas GL API Account Maint. RE Int. extension file valid                           AR739558
      *                                                                                     AR739558
     C                   EVAL      File = 'GLVAMRIPD'                                       AR739558
     C                   EXSR      ReorgFile                                                AR739558
      *
     C                   CLOSE     APDBINFPD
      *
     C                   ENDIF
      *
      ** If an error was found during processing, indicate this to the
      ** COB calling structure by setting on U7 and U8.
      *
     C                   IF        ErrorFound = 'Y'
 
     C                   EVAL      *inu7 = True
     C                   EVAL      *inu8 = True
     C                   EVAL      Switches = 'XXXXXX' + *inu7 + *inu8
 
     C                   RESET                   ReturnCode
     C                   CALLB     'UTSETJOBSW'
     C                   PARM                    ReturnCode
     C                   PARM                    Switches
 
      ** If there was a problem with the switch-setting module set LR
      ** on to update the job switches with the module's copy.
     C                   IF        ReturnCode <> *blank
     C                   EVAL      *inlr = True
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ReorgFile - Reorganize a file                                 *
      *                                                               *
      * Called by: main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ReorgFile     BEGSR
      *
     C                   EVAL      Member = '*FIRST    '
      *
     C                   CALL      'SCC000060'
     C                   PARM                    File
     C                   PARM                    Member
      *
      ** If the return code is not blank, an error has occurred in the
      ** reorganzing process.  Indicate the condition locally, but do not
      ** stop processing.
      *
     C                   IF        *INU7 = '1' and *INU8 = '1'
     C                   EVAL      ErrorFound = 'Y'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Access the API ICD
      ** (database error handling done in access program)
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      **---------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
      *
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2011
