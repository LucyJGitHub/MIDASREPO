     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PB Format MQ series msg for alerter process')
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  PBALERTER - Midas - Format MQ series msg for Alerter process *
      *                                                               *
      *  Function:  Format MQ series message  for Alerter process     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CPB009  *CREATE    Date 12Sep02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CPB009 - PB Operator Message Handling                        *
      *           (PB Alerter - error tracking)                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Test data file (500 bytes, no formatting)
     FPBALERTL1 IF   E           K Disk    usropn
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------------
 
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
     D Queue           S             30A
 
      ** String to send to MQSeries queue
     D String          S           5000A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ I-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
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
 
     C                   open      PBALERTL1
      **  Access Configuration details access program.
     C     K@Full        Chain     PBALERTL1                          99
     c*
     C                   close     PBALERTL1
     C     *IN99         IFEQ      '0'                                          IF CUSTOMER
     C     PBQUEUE       ANDNE     *blank
      ** First set up the queue name
     C                   eval      Queue = PBQUEUE
      ** Overwrite Gravity if needed
     C     P_gravity     ifeq      *blank
     C                   eval      P_gravity = PBLEVEL
     C                   endif
      ** Format the Message
 
     C                   eval      String = P_gravity +                         Gravity
     C                             ';;' +                                       separator
     C                             %trim(PBAPP) +                               Application
     C                             ';;' +                                       separator
     C                             %trim(PBPROCESS) +                           process
     C                             ';;' +                                       separator
     C                             %trim(P_title) +                             title
     C                             ';;' +                                       separator
     C                             %trim(PBSEND) +                              send
     C                             ';;' +                                       separator
     C                             %trim(PBADDRESS) +                            Recipient
     C                             '<end of header>' +                          End of Header
     C                             %trim(PBTITLE) +                             Config Title
     C                             '               ' +                          End of Header
     C                             %trim(P_Body)                                Original Data
 
 
     C                   reset                   ReturnCode
     C                   callb     'ZAMSGTOFO'
     C                   parm                    ReturnCode
     C                   parm                    Queue
     C                   parm                    String
 
     C                   if        ReturnCode <> *blanks
     C                   exsr      *pssr
     C                   endif
     C                   Endif
     C                   eval      *inlr = True
 
     C                   return
 
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
 
      **  Parameters list.
     C     *entry        Plist
     C                   Parm                    P_Gravity         1
     C                   Parm                    P_App            15
     C                   Parm                    P_Process        30
     C                   Parm                    P_Title         255
     C                   Parm                    P_Body         3000
 
     C     K@Full        KLIST
     C                   KFLD                    P_Process                      process
     C                   KFLD                    P_App                          Applicationµ
 
     C/Eject
      *****************************************************************
      **------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------------
 
     C                   Endsr
      *****************************************************************
      **------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
