/*
* Licensed Materials - Property of IBM
* 5725-B69 5655-Y17 5655-Y31 5724-X98 5724-Y15 5655-V82 
* Copyright IBM Corp. 1987, 2018. All Rights Reserved.
*
* Note to U.S. Government Users Restricted Rights: 
* Use, duplication or disclosure restricted by GSA ADP Schedule 
* Contract with IBM Corp.
*/

package monitoringevents;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringWriter;
import java.io.Writer;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.MissingResourceException;
import java.util.ResourceBundle;
import java.util.logging.Logger;

import com.sun.syndication.feed.synd.SyndContent;
import com.sun.syndication.feed.synd.SyndContentImpl;
import com.sun.syndication.feed.synd.SyndEntry;
import com.sun.syndication.feed.synd.SyndEntryImpl;
import com.sun.syndication.feed.synd.SyndFeed;
import com.sun.syndication.feed.synd.SyndFeedImpl;
import com.sun.syndication.feed.synd.SyndImage;
import com.sun.syndication.feed.synd.SyndImageImpl;
import com.sun.syndication.io.FeedException;
import com.sun.syndication.io.SyndFeedInput;
import com.sun.syndication.io.SyndFeedOutput;
import com.sun.syndication.io.XmlReader;

/**
 * A utility class to persist/read RSS data
 */
public class RSSHelper {

	private final static Logger logger = Logger.getLogger(RSSHelper.class
			.getName());

	/**
	 * Whether the RSS file has already been loaded or not
	 */
	private static boolean loaded = false;

	/**
	 * The filename where the RSS data is persisted
	 */
	private String filename;

	/**
	 * The RSS format
	 */
	private String feedType;

	/**
	 * The RSS title
	 */
	private String title;

	/**
	 * The RSS link
	 */
	private String link;

	/**
	 * The RSS description
	 */
	private String description;

	/**
	 * The RSS Author
	 */
	private String author;

	/**
	 * The RSS image
	 */
	private String imageUrl;

	/**
	 * The list of all events
	 */
	private List<SyndEntry> items = new ArrayList<SyndEntry>();

	private String m_port;

	private String m_host;

	public RSSHelper() {
		initProperties();
		filename = "res-monitoringevents.xml";
		feedType = "rss_2.0";
		title = "Sample Execution Events";
		link = getRESHomeLink();
		description = "This RSS feed contains the Rule Execution Server RuleApp/Ruleset modification events";
		author = "Monitoring Events Sample";
		imageUrl = getRESHomeLink() + "/images/empty.gif";
		try {
			load();
		} catch (java.io.FileNotFoundException e) {
			// nothing to do if no backup
		} catch (Exception e) {
			logger.severe(e.getMessage());
		}
	}

	/**
	 * Initialization of properties
	 */
	private void initProperties() {
		try {
			ResourceBundle rb = ResourceBundle.getBundle("build");
			m_port = rb.getString("server.port");
			m_host = "localhost";
		} catch (MissingResourceException e) {
			System.out
					.println("No bundle found. Use the default port and host.");
			m_port = "9090";
			m_host = "localhost";
		}
	}

	/**
	 * Load the events from the file
	 * 
	 * @throws IllegalArgumentException
	 * @throws FeedException
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	public synchronized void load() throws IllegalArgumentException,
			FeedException, IOException {
		if (loaded)
			return;
		loaded = true;
		File f = new File(filename);
		logger.info("Loading RSS news from file " + f.getAbsolutePath());
		SyndFeedInput input = new SyndFeedInput();
		SyndFeed feed = input.build(new XmlReader(f));
		items = feed.getEntries();
		logger.info("Loaded  " + items.size() + " RSS new(s)");
	}

	/**
	 * Clear all events
	 * 
	 * @throws IOException
	 * @throws FeedException
	 */
	public synchronized void reset() throws IOException, FeedException {
		items.clear();
		save();
	}

	/**
	 * Write to a writer the file contents in the RSS format
	 * 
	 * @param writer
	 * @throws IOException
	 * @throws FeedException
	 */
	private synchronized void write(Writer writer) throws IOException, FeedException {
		SyndFeed feed = new SyndFeedImpl();
		feed.setFeedType(feedType);
		feed.setTitle(title);
		feed.setLink(link);
		feed.setDescription(description);
		SyndImage image = new SyndImageImpl();
		image.setTitle(title);
		image.setLink(link);
		image.setUrl(imageUrl);
		feed.setImage(image);
		feed.setEntries(items);
		SyndFeedOutput output = new SyndFeedOutput();
		output.output(feed, writer);
	}

	/**
	 * Save all events to the file
	 * 
	 * @throws IOException
	 * @throws FeedException
	 */
	public void save() throws IOException, FeedException {
		File f = new File(filename);
		logger.info("Saving " + items.size() + " RSS new(s) to file " + f.getAbsolutePath());
		Writer writer = new FileWriter(f);
		write(writer);
		writer.close();
	}

	/**
	 * Read the events stored in the file
	 * 
	 * @return the events as a String
	 * @throws IOException
	 * @throws FeedException
	 */
	public String get() throws IOException, FeedException {
		Writer writer = new StringWriter();
		write(writer);
		writer.close();
		return writer.toString();
	}

	/**
	 * @param author :
	 *          The author of the event
	 * @param title :
	 *          The title of the event
	 * @param link :
	 *          The link to the element in RES
	 * @param date :
	 *          The event's date
	 * @param desc :
	 *          The event's description
	 */
	public synchronized void createEntry(String title, String link, Date date, String desc) {
		SyndEntry entry = new SyndEntryImpl();
		entry.setTitle(title);
		entry.setLink(link);
		entry.setPublishedDate(date);
		entry.setAuthor(author);
		SyndContent description = new SyndContentImpl();
		description.setType("text/plain");
		description.setValue(desc);
		entry.setDescription(description);
		items.add(entry);
	}

	public  String getRESHomeLink() {
		StringBuffer link = new StringBuffer();
		link.append("http://");
		link.append(getHostname());
		link.append(":");
		link.append(getPort());
		link.append("/res");
		return link.toString();
	}

	public  String getHostname() {
		return m_host;
	}

	public  String getPort() {
		return m_port;
	}
	
}
