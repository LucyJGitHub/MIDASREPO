     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas UT Send test data from file to MQSeries Q')      *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000001 - Send API Data to an MQ Queue                      *
      *                                                               *
      *  Function:  This module sends API data to an MQ Queue and     *
      *             is called by the SNDAPIDTA command                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT039             Date 28Sep12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CIR003             Date 13Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CMK002  *CREATE    Date 07Sep00               *
      *                 XXXXXX             Date 00Xxx00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT039 - SWIFT Mapping of Field Ordering Bank                *
      *           Amendment done to accommodate longer data           *
      *  CIR003 - Principal Exchange on Cross Currencies IRS          *
      *  CMK002 - SNDAPIDATA added to core                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Test data file (4000 bytes, no formatting)
     FUTSNDAPIPDIF   E             DISK    rename(TESTDATA:TESTDATAF)
 
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
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
      ** +--- Named indicators -------------------------------------------+
      ** ¦                                                                ¦
      ** ¦ Map variable names to indicators to allow use of names instead ¦
      ** ¦ of numbers; base the following data structure on a pointer to  ¦
      ** ¦ the indicator array.                                           ¦
     D Indicators      DS                  BASED(pIndicator)
      ** ¦                                                                ¦
     D  EoF                   99     99
      ** ¦                                                                ¦
      ** ¦ Set the indicator array pointer                                ¦
     D pIndicator      S               *   INZ(%Addr(*In))
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Midas system prefix
     D Prefix          S              2A
 
      ** The transaction queue to send to
     D Queue           S             20A   INZ('MIDASxx.TRANSACT.Q')
 
      ** String to send to MQSeries queue
     D*String***       S           4000A                                                      CIR003
     D*String***       S           6000A                                               CIR003 CFT039
     D String          S          12000A                                                      CFT039
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ I-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     ITESTDATAF
      ** Rename the field in TESTDATA to prevent confusion
     I              TESTDATA                    TESTD
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Processing: read a record and send its contents to the transaction
      ** queue of the Midas system defined by the received prefix.
 
      ** First set up the queue name
     C                   eval      %subst(Queue : 6 : 2) = Prefix
 
      ** Read the file until the end
 
     C                   dou       EoF = True
 
     C                   read      UTSNDAPIPD                             99
 
     C                   if        EoF = True
     C                   leave
     C                   endif
 
     C                   eval      String = TESTD
 
     C                   reset                   ReturnCode
     C                   callb     'ZA000001'
     C                   parm                    ReturnCode
     C                   parm                    Queue
     C                   parm                    String
 
     C                   if        ReturnCode <> *blanks
     C                   exsr      *pssr
     C                   endif
 
     C                   enddo
 
      ** Send a shutdown message
     C                   eval      String = 'SHUTDOWN'
 
     C                   reset                   ReturnCode
     C                   callb     'ZA000001'
     C                   parm                    ReturnCode
     C                   parm                    Queue
     C                   parm                    String
 
     C                   if        ReturnCode <> *blanks
     C                   exsr      *pssr
     C                   endif
 
     C                   eval      *inlr = *on
 
     C                   RETURN
 
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
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Outputs from this procedure
      ** ---------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
 
      ** Inputs to this procedure
      ** ------------------------
      ** Midas system prefix
     C                   PARM                    Prefix
 
 
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
