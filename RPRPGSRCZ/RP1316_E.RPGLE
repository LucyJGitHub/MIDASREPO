     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB RPDSPSCRPT command exit program module')
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1316_E - Midas PB RPDSPSCRPT command exit program module.  *
      *                                                               *
      *  Function: this module allows to set text for possible choice *
      *            that is placed to the right of the input field     *
      *            on the prompt display.                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CPB002  *CREATE    Date 21Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **  Source file that contains all scripts.
     FX110LF    IF   E             Disk    Infsr(*Pssr)
 
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  81  -  End of file X110LF.                                   *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *                  *************************                    *
      *                  ** INDICATORS NOT USED **                    *
      *                  *************************                    *
      *                                                               *
      *       ***************************************************     *
      *       * 01   02   03   04   05   06   07   08   09   10 *     *
      *       * 11   12   13   14   15   16   17   18   19   20 *     *
      *       * 21   22   23   24   25   26   27   28   29   30 *     *
      *       * 31   32   33   34   35   36   37   38   39   40 *     *
      *       * 41   42   43   44   45   46   47   48   49   50 *     *
      *       * 51   52   53   54   55   56   57   58   59   60 *     *
      *       * 61   62   63   64   65   66   67   68   69   70 *     *
      *       * 71   72   73   74   75   76   77   78   79   80 *     *
      *       * xx   82   83   84   85   86   87   88   89   90 *     *
      *       * 91   92   93   94   95   96   97   98   99      *     *
      *       ***************************************************     *
      *                                                               *
      *****************************************************************
      /Space 3
      *****************************************************************
      *                                                               *
      *                S U B R O U T I N E   I N D E X                *
      *                -------------------------------                *
      *                                                               *
      *  #Sndms - Subroutine to send message to Program Message Queue.*
      *  *Pssr  - Program exception error routine.                    *
      *  *inzsr - Program Initialization routine.                     *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **  The following /COPY contains various standard declares
     D/COPY RPCPYSRC,Std_Dcl
 
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
 
      ** Array containing Copyright statement
     D Cpy@            S             80    Dim(1) Ctdata Perrcd(1)
 
      **  External Data structure for Local data area for database error details.
     D LDA           E DS           256    EXTNAME(LDA)
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      **  Array used to store Meridian Products names.
     D ArrProd         S              1    Dim(800)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **-------------------- Start of Parameters --------------------**
      **  Input parameter.
     D Input           DS            21
     D   CommandName           1     10
     D   KeywordName          10     20
     D   DataType             21     21
 
      **  Output parameter
     D Output          S             30
      **--------------------- End of Parameters ---------------------**
 
      **  Indexes to manage array enries.
     D P               S              2S 0
     D X               S              2S 0
 
      **  Total number of entries.
     D W_Last          S              2S 0
 
     D W_RunBefore     S              1A
 
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /Eject
      *****************************************************************
     C     Start         Tag
 
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      *****************************************************************
      *                                                               *
      *                  M A I N  P R O C E S S I N G                 *
      **   +------------------------------------------------------+   *
      **   ¦                                                      ¦   *
      **   ¦ Initial processing is performed automatically: the   ¦   *
      **   ¦ *inzsr is executed at program activation.            ¦   *
      **   ¦                                                      ¦   *
      **   +------------------------------------------------------+   *
      *                                                               *
      *****************************************************************
 
      **  Read Meridian DBA Products file.
     C                   Read      X110LF                                 81
 
      **  Process all records.
     C     *In81         Doweq     False                                        Begin Do_W_81
 
     C                   Eval      P = P + 1
     C                   Eval      X = %Len(%trim(Output)) + 1
     C                   if        X > 1
     C                   Movea     ','           ArrProd(X)
     C                   Eval      X = X + 2
     C                   Endif
     C                   Movea     X1PRDN        ArrProd(X)
     C                   Movea     ArrProd(1)    Output
 
      **  Read next record from file.
     C                   Read      X110LF                                 81
 
     C                   Enddo                                                  End Do_W_81
 
      **  Exit from program.
     C                   Eval      *inlr = true
 
      /Eject
      *****************************************************************
      /Title SR/*Pssr
      *****************************************************************
      *                                                               *
      * *Pssr  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     *Pssr         Begsr
 
     C     W_RunBefore   Ifeq      *blank                                       Begin W_RunBefore
     C                   Move      'Y'           W_RunBefore
     C                   Dump
 
     C                   Endif                                                  End W_RunBefore
 
     C                   Eval      *inu7 = True
     C                   Eval      *inu8 = True
     C                   Eval      *inlr = True
     C                   Return
 
     C                   Endsr
 
      /Eject
      *****************************************************************
      /Title SR/*Inzsr
      *****************************************************************
      *                                                               *
      * *Inzsr - Program Initialisation routine                       *
      *                                                               *
      *  Called By: Implicitly on program activation.                 *
      *                                                               *
      *****************************************************************
 
     C     *Inzsr        Begsr
 
      **  List of parameters.
     C     *Entry        Plist
 
      **--------------------- input parameters ----------------------**
 
     C                   Parm                    Input
 
      **   1-10   Command name. Specifies the name of the command being
      **          processed that causes the program to run.
      **  11-20   Keyword name. Specifies the keyword for which possible
      **          choices or permissible values are being requested.
      **     21   C or P character indicating the type of data being requested
      **          by prompter.  The letter C indicates that this is a 30-byte
      **          field into which the text for possible choices is to be
      **          returned. The letter P indicates that this a 2000-byte field
      **          into which a permissible values list is to be returned.
 
      **--------------------- Output parameters ---------------------**
 
     C                   Parm                    Output
 
      **  Parameter 2: A 30- or 2000-byte field for returning one of the
      **  following:
      **
      **  -   If C is in byte 21 of the first parameter, this indicates that the
      **      text for possible choices will return. Additionally, this is a
      **      30-byte field where the program places the text to the right of
      **      the input field on the prompt display.
      **
      **  -   If P is in byte 21 of the first parameter (indicating that a
      **      permissible values list is to be returned), this is a 2000-byte
      **      field into which the program is to place the list. The first two
      **      bytes of the list must contain the number of entries (in binary)
      **      in the list. This value is followed by entries that consist of a
      **      2-byte binary length followed by the value, which must be 1 to 32
      **      characters long.
      **
      **      If a binary zero value is returned in the first two bytes, no
      **      permissible values are displayed.
      **
      **      If a binary negative value is returned in the first two bytes, the
      **      list of permissible values is taken from the command.
 
     C                   Endsr
 
      /Eject
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
